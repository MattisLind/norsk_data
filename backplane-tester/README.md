# Two-card backplane continuity tester

KiCad schematic, revision C — 2026-10-27.

Two identical USB-powered cards discover the electrical connections between
two slots of a **bare, unpowered backplane with nothing else connected**.
Each card selects any of 100 contacts through seven CD74HC4067 multiplexers
and an eighth CD74HC4067 that selects the bank. An STM32F103C8T6 controls
selection, excitation and ADC measurements. A laptop assigns the two roles
and combines successive slot-pair scans into a measured netlist.

Open [kicad/backplane-tester.kicad_pro](kicad/backplane-tester.kicad_pro)
in **KiCad 9 or later**, then open its root schematic. The project contains
nine editable schematic sheets and a project-local symbol library.
PCB layout and executable firmware are not included.
Connector dimensions, contact numbering and the electrical prototype still
need checking before a board can be manufactured.

## Design files

| File | Contents |
| --- | --- |
| [kicad/backplane-tester.kicad_pro](kicad/backplane-tester.kicad_pro) | KiCad project |
| [kicad/backplane-tester.kicad_sch](kicad/backplane-tester.kicad_sch) | Root schematic and eight child sheets |
| [kicad/README.md](kicad/README.md) | Sheet guide, connector placeholders, validation and library attribution |
| [hardware.md](hardware.md) | Circuit connections, USB/power/clock support, calculations and bring-up |
| [protocol.md](protocol.md) | Proposed firmware behavior, USB commands and laptop scan sequence |
| [mcu-pinout.csv](mcu-pinout.csv) | All 48 MCU package pins and their proposed assignments |
| [contact-map.csv](contact-map.csv) | All 100 logical contacts, mux channels and physical IC pins |
| [bom.csv](bom.csv) | Preliminary BOM for **one** board; build two |
| [sources.md](sources.md) | Primary datasheets and design references |

## Main choices

- **U1: STM32F103C8T6**, LQFP48, operated at 48 MHz. It has sufficient GPIO,
  an ADC and USB device support. C8 firmware must fit its specified 64 KiB
  flash; do not rely on undocumented extra flash in some modules.
- **U2–U8: CD74HC4067M**, SOIC24, first-stage banks 0–6.
- **U9: CD74HC4067M**, SOIC24, second-stage bank selector.
- All electronics operate at **3.3 V**, locally regulated from each USB port.
- Test highs are approximately **2.0 V**, made by GPIO resistor dividers.
  This gives headroom below both boards' independently regulated mux supplies.
- Two USB CDC serial connections provide host control and coordinate scans.
  A single wire between J3 on the two cards joins their grounds.
- A separate J5 USART1 header provides application debug serial access and
  firmware downloading through the STM32's built-in serial bootloader.
  JP1 selects serial boot mode; SW1 resets the processor. SWD is also retained.
- Every backplane contact goes only to a mux input. No contact, including an
  apparent power or ground contact, is hardwired to tester ground or supply.

The 100 contacts are named `BP000`–`BP099` here. These are logical identities,
**not established NORD connector terminal numbers or a mechanical pinout**.
The physical-label column in the mapping is deliberately blank until a real
card and connector have been measured. For example, logical address 0 might
eventually correspond to printed terminal 0 or 1; the design does not decide it.

## What a scan establishes

One transmitter contact is tested against all 100 receiver contacts, retaining
the complete 100 × 100 matrix. Software groups connected endpoints into nets
and compares them with an expected netlist when one exists. Matching contact
numbers are not assumed to mean matching signals.

A fixed reference slot only covers nets reaching that slot. Move both boards
as needed, or scan every unordered slot pair for exhaustive inter-slot coverage.
Joins confined entirely to a single slot cannot be discovered by two cards
occupying different slots; those require an additional same-slot probe path.
The result is electrical connectivity, not the physical wire-wrap route:
parallel paths can conceal a broken individual wire.

The first prototype should prove known opens, connected wires, joined nets,
added resistances and capacitive settling before the full 100-contact PCB.

## Schematic checks performed

Checked all 100 logical routes for unique first-stage inputs, the 95/96 bank
boundary and final contact 99; checked all 48 MCU package pins, BOM reference
counts and local document links. The KiCad schematic was exported and its
rendered sheets visually reviewed. Nominal divider/path calculations were checked, including supply
and resistor tolerance margin for the approximately 2 V test high.

KiCad 9.0.9 ERC reports **zero errors and zero warnings**, without ERC
exclusions. Its exported netlist is checked against all 146 specified nets,
the contact map, MCU pin table and 78-component BOM. Details and commands are
in [kicad/README.md](kicad/README.md).

No hardware measurements, SPICE simulation, firmware build, PCB design-rule
check or USB compliance test has been performed.
