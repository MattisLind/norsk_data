# Backplane tester KiCad project

Open **backplane-tester.kicad_pro** with KiCad 9 or later, then open
**backplane-tester.kicad_sch**. This is an electrically connected schematic,
not a graphical diagram. It contains 78 distinct physical components.
There is no PCB layout in this project yet.

## Sheets

| Page | File | Circuit |
| --- | --- | --- |
| 1 | [backplane-tester.kicad_sch](backplane-tester.kicad_sch) | Project overview and navigation |
| 2 | [controller.kicad_sch](controller.kicad_sch) | STM32, oscillator, reset/boot, address defaults and MCU decoupling |
| 3 | [usb-power.kicad_sch](usb-power.kicad_sch) | USB connector, regulator, ESD, attach switch and VBUS sensing |
| 4 | [measurement.kicad_sch](measurement.kicad_sch) | Four stimulus branches, ADC filter and measurement test points |
| 5 | [programming.kicad_sch](programming.kicad_sch) | Ground-only interconnect, debug/boot UART, SWD, LED and test points |
| 6 | [mux-banks-0-1.kicad_sch](mux-banks-0-1.kicad_sch) | U2/U3, contacts BP000–BP031 |
| 7 | [mux-banks-2-3.kicad_sch](mux-banks-2-3.kicad_sch) | U4/U5, contacts BP032–BP063 |
| 8 | [mux-banks-4-5.kicad_sch](mux-banks-4-5.kicad_sch) | U6/U7, contacts BP064–BP095 |
| 9 | [mux-bank-6-root.kicad_sch](mux-bank-6-root.kicad_sch) | U8, final four contacts, and U9 root selector |

Global net labels intentionally join the sheets. Contact wires use local
`BPxxx` labels within their bank sheet. J1A–J1G are seven units of the same
component, not seven physical connectors. No inter-board serial or sync wire
is included: J3.1 connects only to the other card's J3.1 / GND.

J5 is a separate **3.3 V logic** USART1 debug/ROM-programming connector:
1=GND, 2=card TX, 3=card RX, 4=NRST, 5=BOOT0. For manual programming, fit
JP1 and reset with SW1; program through USART1; remove JP1 and reset to run.
Full operating instructions remain in [hardware.md](../hardware.md).

## Connector and footprint status

**J1 pin numbers L000–L099 are logical placeholders**, deliberately distinct
from unknown physical connector terminal numbers. For example, J1.L096
connects BP096 to U8 pin 9. Its value/description identify the mechanical hold.
Check a real card/connector before assigning physical numbers, footprint,
board edge, pitch, thickness, keying and insertion depth.

Standard package footprints are assigned where established. J1, J2, Y1 and
SW1 remain without footprints because their physical parts have not been
selected. C8/C9 remain provisional crystal-load values. This schematic is a
reviewable electrical design, not a fabrication release.

## Libraries and attribution

[BackplaneTester.kicad_sym](BackplaneTester.kicad_sym) is a project-local
library, registered by [sym-lib-table](sym-lib-table). Every sheet also embeds
its used symbols. No personal/global library configuration is needed.

Standard component symbols are derived from the official
[KiCad symbol libraries, tag 9.0.0](https://gitlab.com/kicad/libraries/kicad-symbols/-/tree/9.0.0):
Device, MCU_ST_STM32F1, 74xx, Regulator_Linear, Transistor_BJT,
Power_Protection, Connector, Connector_Generic, Switch and power.
Inherited symbols were flattened and collected under the BackplaneTester
library name; the logical 100-contact connector is project-specific.
See [SYMBOL-LICENSE.md](SYMBOL-LICENSE.md) for the KiCad library license and
exception. Library licensing does not require a circuit design using these
symbols to be licensed under the library license.

## Checks

Validated using **KiCad CLI 9.0.9** on 2026-10-27:

- All nine sheets loaded and rendered for visual review.
- ERC: zero errors, zero warnings, no exclusions.
- Exported netlist: all 146 specified nets match the captured circuit intent.
- All 100 contact paths, all 48 MCU package pins, and the 78-component BOM
  match their CSV tables. The backplane has no permanently grounded contact.
- The 34 unused MCU, USB-ID and mux pins carry explicit no-connect markers.

Run from this directory with a local KiCad installation:

```sh
kicad-cli sch erc --exit-code-violations --format json --output /tmp/backplane-erc.json backplane-tester.kicad_sch
kicad-cli sch export netlist --format kicadxml --output /tmp/backplane-netlist.xml backplane-tester.kicad_sch
python3 verify_netlist.py /tmp/backplane-netlist.xml
```

[expected-nets.json](expected-nets.json) captures the intended schematic
connections for the comparison. When intentionally changing the circuit,
update that file and the hardware/CSV specifications as appropriate.
ERC and netlist checks do not replace hardware validation, USB signal checks,
power/inrush measurement, or PCB design-rule checking.
