#!/usr/bin/env python3
"""Compare a KiCad XML export with the design intent and independent CSV tables."""
import argparse
import csv
import json
from pathlib import Path
import xml.etree.ElementTree as ET


def check(path):
    here = Path(__file__).resolve().parent
    design = ET.parse(path).getroot()
    actual = {}
    for net in design.findall('./nets/net'):
        # Local contact-net labels acquire their bank-sheet path in the export.
        name = net.attrib['name'].rsplit('/', 1)[-1]
        if name in actual:
            raise ValueError(f'Ambiguous net label across sheets: {name}')
        actual[name] = sorted((p.attrib['ref'], p.attrib['pin']) for p in net.findall('node'))
    expected = json.loads((here / 'expected-nets.json').read_text())
    for name, nodes in expected.items():
        wanted = sorted(tuple(p) for p in nodes if not p[0].startswith('#'))
        if actual.get(name) != wanted:
            raise ValueError(f'{name}: expected {wanted}, got {actual.get(name)}')
    unexpected = set(actual) - set(expected)
    if any(not name.startswith('unconnected-') for name in unexpected):
        raise ValueError(f'Unexpected nets: {sorted(unexpected)}')

    # These CSV files predate the CAD conversion and check the intended mapping.
    with (here.parent / 'contact-map.csv').open(newline='') as f:
        contacts = list(csv.DictReader(f))
    if len(contacts) != 100:
        raise ValueError('Expected 100 contact-map rows')
    for row in contacts:
        address = int(row['logical_address'])
        name = row['logical_net']
        want = sorted([('J1', f'L{address:03d}'),
                       (row['first_stage_ref'], row['first_stage_input_pin'])])
        if actual.get(name) != want:
            raise ValueError(f'Contact mapping mismatch: {name}')
        bank_net = f"BANK{row['bank']}"
        if (row['first_stage_ref'], row['first_stage_common_pin']) not in actual[bank_net]:
            raise ValueError(f'Bank common mapping mismatch: {name}')
        if (row['root_ref'], row['root_input_pin']) not in actual[bank_net]:
            raise ValueError(f'Root-bank mapping mismatch: {name}')
    by_pin = {p: net for net, nodes in actual.items() for p in nodes}
    with (here.parent / 'mcu-pinout.csv').open(newline='') as f:
        mcu = list(csv.DictReader(f))
    if len(mcu) != 48:
        raise ValueError('Expected 48 MCU pin rows')
    for row in mcu:
        got = by_pin.get(('U1', row['package_pin']))
        if row['net'] == 'NC':
            if got is not None and not got.startswith('unconnected-'):
                raise ValueError(f"Unexpected connection on MCU pin {row['package_pin']}: {got}")
        elif got != row['net']:
            raise ValueError(f"MCU pin {row['package_pin']}: expected {row['net']}, got {got}")
    with (here.parent / 'bom.csv').open(newline='') as f:
        bom = list(csv.DictReader(f))
    refs = []
    for row in bom:
        parts = row['references'].split()
        if len(parts) != int(row['quantity_per_board']):
            raise ValueError(f'BOM count mismatch: {row}')
        refs.extend(parts)
    components = {p.attrib['ref'] for p in design.findall('./components/comp')}
    if len(refs) != len(set(refs)) or set(refs) != components:
        raise ValueError(f'BOM differs from schematic: {set(refs) ^ components}')
    print(f'PASS: {len(expected)} nets, {len(contacts)} contact routes, '
          f'{len(mcu)} MCU pins and {len(components)} physical components.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('netlist', type=Path)
    check(parser.parse_args().netlist)
