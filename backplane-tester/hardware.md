# Hardware and KiCad schematic — revision C

Component quantities and reference designators are per board. The two boards
have the same hardware and firmware. [Sources](sources.md) identify the
datasheets used; resistor values, timings and thresholds below are design
proposals to validate on the prototype.

The editable circuit is in [kicad/backplane-tester.kicad_pro](kicad/backplane-tester.kicad_pro).
Open the project and its root schematic to navigate the nine sheets.

## 1. Contact selector

Use eight **CD74HC4067M** devices, 3.3 V supply, SOIC24. Do not substitute the
HCT variant at this supply voltage. Put 100 nF directly across pins 24/12 of
each mux. U2–U8 are first-stage banks; U9 selects a bank.

| Device | Bank | Logical inputs | Common pin 1 connects to |
| --- | --- | --- | --- |
| U2 | 0 | BP000–BP015 | U9 I0, pin 9 |
| U3 | 1 | BP016–BP031 | U9 I1, pin 8 |
| U4 | 2 | BP032–BP047 | U9 I2, pin 7 |
| U5 | 3 | BP048–BP063 | U9 I3, pin 6 |
| U6 | 4 | BP064–BP079 | U9 I4, pin 5 |
| U7 | 5 | BP080–BP095 | U9 I5, pin 4 |
| U8 | 6 | BP096–BP099 on I0–I3 | U9 I6, pin 3 |

Leave U8 I4–I15 and U9 I7–I15 unconnected. U9 common pin 1 is `MEAS`.
Unused analogue inputs are not grounded. Every populated contact, including
backplane power/ground contacts, uses this same arrangement.

| Net | MCU | Mux connections |
| --- | --- | --- |
| ADDR0 | PB8, pin 45 | U2–U8 S0, pin 10 |
| ADDR1 | PB9, pin 46 | U2–U8 S1, pin 11 |
| ADDR2 | PB10, pin 21 | U2–U8 S2, pin 14 |
| ADDR3 | PB11, pin 22 | U2–U8 S3, pin 13 |
| ADDR4 | PB12, pin 25 | U9 S0, pin 10 |
| ADDR5 | PB13, pin 26 | U9 S1, pin 11 |
| ADDR6 | PB14, pin 27 | U9 S2, pin 14 |
| MUX_DISABLE | PB15, pin 28 | U2–U9 E, pin 15; R1 10 kΩ to 3.3 V |
| GND | — | U2–U9 pin 12 and U9 S3, pin 13 |
| 3V3 | — | U2–U9 pin 24 |

E high disables all eight devices. Pull address nets low with R2–R8, 100 kΩ
each, so control inputs do not float at reset. These resistors are on digital
address nets, not on backplane contacts. Set `MUX_DISABLE` high before
configuring any stimulus pin. The address fits PB[14:8], permitting an atomic
port update without using debug, USB or boot pins.

For address `a` in 0–99, `bank = a >> 4`, `channel = a & 15`.
Physical analogue-pin mapping is in [contact-map.csv](contact-map.csv).

When enabled, each first-stage mux selects one contact in its own bank.
Only one bank is connected through U9 to MEAS. The other six selected
contacts end at separate, unselected U9 inputs; they are not joined together.
Unselected channels still have semiconductor leakage and capacitance.

## 2. Stimulus and detector

See the **Stimulus and ADC** sheet,
[measurement.kicad_sch](kicad/measurement.kicad_sch), in the KiCad project.

U9 common `MEAS` connects to:

| Branch | Connection |
| --- | --- |
| Strong upper | PA1, U1 pin 11 → R9 1 kΩ → MEAS |
| Strong lower | PA2, U1 pin 12 → R10 1.5 kΩ → MEAS |
| Weak upper | PA4, U1 pin 14 → R11 10 kΩ → MEAS |
| Weak lower | PA5, U1 pin 15 → R12 15 kΩ → MEAS |
| Detector | MEAS → R13 100 Ω → ADC_SENSE → PA0/ADC1_IN0, U1 pin 10 |
| ADC reservoir | C1 1 nF from ADC_SENSE to GND |

Use 1% resistors. There are no permanent pull resistors on MEAS. An inactive
stimulus GPIO is configured as **analogue input**, with its digital buffer
and internal pulls disabled. ADC_SENSE is always an analogue input.

The two divider branches replace the earlier two-resistor, rail-high sketch.
With independent USB regulators, a rail-high from one board could exceed
the other board's mux supply. Divider highs keep the test voltage well below
both 3.3 V rails without joining regulator outputs or adding another IC.

`Z` below means analogue-input/high impedance; `H` and `L` mean push-pull
GPIO output high/low. All unlisted stimulus pins remain Z.

| Mode | PA1 strong upper | PA2 strong lower | PA4 weak upper | PA5 weak lower |
| --- | --- | --- | --- | --- |
| FLOAT | Z | Z | Z | Z |
| DRIVE_LOW | L | Z | Z | Z |
| DRIVE_HIGH | H | L | Z | Z |
| BIAS_LOW | Z | Z | L | Z |
| BIAS_HIGH | Z | Z | H | L |

Never enable a lone upper GPIO high: the lower divider GPIO must already
be low. Change modes with muxes disabled: first release upper GPIOs, then
configure lower GPIOs, then enable the required upper GPIO. Release upper
GPIOs before lower GPIOs when returning to FLOAT.

At nominal 3.3 V, ignoring GPIO output resistance:

```text
High voltage        = 3.3 × 1.5 / (1 + 1.5) = 1.98 V
DRIVE_HIGH Rsource  = 1 kΩ || 1.5 kΩ         = 600 Ω
BIAS_HIGH Rsource   = 10 kΩ || 15 kΩ         = 6 kΩ
DRIVE_LOW Rsource   = 1 kΩ
BIAS_LOW Rsource    = 10 kΩ
```

These are nominal calculations, not guaranteed voltage specifications.
Local supply tolerance, GPIO output voltage, leakage and mux resistance
affect readings. Even an unloaded divider high stays comfortably below the
other board's minimum 3.3 V supply with normal component tolerances.

For a connected low test, let `Rp` be the sum of **all four mux on-resistances**
plus the wire/contact resistance. The receiver MEAS voltage is approximately:

```text
Vreceiver_low = Vbias_high × (1 kΩ + Rp) / (6 kΩ + 1 kΩ + Rp)
```

For a connected high test:

```text
Vreceiver_high = Vdrive_high × 10 kΩ / (600 Ω + Rp + 10 kΩ)
```

With an illustrative `Rp = 600 Ω` these are about 0.42 V and 1.77 V.
That resistance is an analysis example, **not a 4067 specification at 3.3 V**.
Do not extrapolate the datasheet's 4.5 V typical resistance into a guaranteed
3.3 V value. Characterize real devices at the intended supply and temperature.

An open low-test path reads near the receiver's own BIAS_HIGH voltage; an
open high-test path reads near zero. Both boards can record the source-side
ADC as well, making voltage-drop checks and diagnostics possible. This is a
continuity instrument, not a precision low-ohms meter.

## 3. STM32 core

U1 is **STM32F103C8T6**, LQFP48. [mcu-pinout.csv](mcu-pinout.csv) lists every
pin; it is cross-checked against the KiCad exported netlist.

- U1 VDD pins 24, 36, 48 → 3V3; VSS pins 23, 35, 47 → GND.
  C2–C4: 100 nF, one at each VDD/VSS pair.
- VBAT pin 1 → 3V3; C5 100 nF to GND; no battery is required.
- VDDA pin 9 → 3V3 through R14 0 Ω. C6 100 nF and C7 1 µF to GND
  at VDDA. VSSA pin 8 → GND. Use a continuous ground plane.
- Y1: 8 MHz crystal between OSC_IN pin 5 and OSC_OUT pin 6.
  C8/C9: provisionally 18 pF from each end to GND. Final values depend on
  the chosen crystal's load capacitance and PCB stray capacitance; for
  approximately equal capacitors, `CL ≈ C/2 + Cstray`.
- NRST pin 7: R15 10 kΩ to 3V3, C10 100 nF to GND, SW1 to GND;
  also route to SWD.
- BOOT0 pin 44: R16 10 kΩ to GND; JP1 can connect BOOT0 to 3V3.
  BOOT1/PB2 pin 20: R17 10 kΩ to GND. Normally leave JP1 open.
- PA13 pin 34 → SWDIO; PA14 pin 37 → SWCLK. Keep both reserved.
- PA6 pin 16 → R18 2.2 kΩ → D1 status LED anode; LED cathode → GND;
  active high.

Proposed clock tree: HSE 8 MHz → PLL ×6 → SYSCLK/USB 48 MHz; USB divider
1; APB1 24 MHz; APB2 48 MHz; ADC prescaler /4 → 12 MHz. Configure flash
latency appropriately before switching clocks. No LSE crystal is needed.

ADC proposal: calibration at startup; 239.5-cycle sample time; discard one
conversion after a channel change; average eight conversions. Start with
1 ms settling after connecting a new backplane contact. Confirm settling
on the largest actual nets and repeat with longer delays if readings vary.

## 4. USB and power

J2 is a USB Micro-B receptacle, selected for a simple low-cost prototype.
Each board powers itself from its own USB cable. There is no supply feed
from the backplane or inter-board cable.

| Connection | Proposed circuit |
| --- | --- |
| J2.1 VBUS | USB_5V, to U10 VIN pin 3; C11 1 µF to GND |
| U10 | MCP1700T-3302E/TT, SOT23; pin 1 GND, pin 2 3V3, pin 3 USB_5V |
| 3V3 bulk | C12 4.7 µF at U10 output; C13 4.7 µF near MCU/mux supply distribution |
| J2.2 D− | USB_DM_CONN → R19 22 Ω → U1 PA11, pin 32 |
| J2.3 D+ | USB_DP_CONN → R20 22 Ω → U1 PA12, pin 33 |
| J2.4 ID | Unconnected |
| J2.5 GND and shell | Tester GND; final shell treatment may be revisited for EMC |
| U11 USBLC6-2SC6 | Pins 1/6 to USB_DM_CONN; 3/4 to USB_DP_CONN; pin 2 GND; pin 5 USB_5V |
| VBUS detector | USB_5V → R21 100 kΩ → PA3, U1 pin 13 → R22 100 kΩ → GND |

U11 sits immediately behind the connector, with a short ground return and
C22 100 nF from its VBUS pin to GND.
Provision R19/R20 as initial tuning values; confirm USB signal quality and
the selected STM32 implementation before freezing their population.

The F103 needs an external D+ pull-up. Make it switchable:

```text
3V3 ─────────────── Q1 emitter
                       Q1 = BC857B, PNP, SOT23
3V3 ── R23 100 kΩ ─ Q1 base ── R24 10 kΩ ── PB1 (U1.19)
                    Q1 collector ── R25 1.5 kΩ, 1% ── USB_DP_CONN
```

For Nexperia Q1 the SOT23 assignment is base 1, emitter 2, collector 3;
verify the purchased transistor's datasheet/footprint. PB1 is open-drain:
low attaches USB; released disconnects. The base pull-up keeps USB detached
during MCU reset. Assert attach only after clocks and the USB stack are ready
and VBUS is detected. This also permits software re-enumeration.

Target consumption is below 100 mA per card, to be verified on the prototype.
Configure the USB power descriptor accordingly, implement USB suspend, and
keep muxes off during suspend. Decoupling and regulator bulk capacitance
must be checked against USB startup/inrush requirements before PCB release.
Supply the debug connector's 3V3 as a reference, not as an extra power input.

## 5. Ground connection, debug serial and programming

### J3: one inter-board ground connection

J3 is a single GND pin or ground-wire attachment point. Connect J3.1 on A to
J3.1 on B with one short wire. There are no inter-board UART, synchronization
or power signals. PA8 is unused. The laptop coordinates selection and sampling
through USB commands and acknowledgements. Both cards are powered from their
own USB ports before scanning.

### J5: USART1 debug and ROM-bootloader header

J5 is a separate 1×5, 2.54 mm header for an external **3.3 V logic USB-to-UART
adapter**. TX/RX names are relative to the tester card, not the adapter.

| J5 pin | Signal | Connection | External adapter |
| --- | --- | --- | --- |
| 1 | GND | Tester ground | GND |
| 2 | DEBUG_TX | PA9 / U1.30 through R26 1 kΩ | Adapter RX |
| 3 | DEBUG_RX | PA10 / U1.31 through R27 1 kΩ | Adapter TX |
| 4 | NRST | U1.7; R15 pull-up, C10 and SW1 to GND | Optional open-drain reset control |
| 5 | BOOT0 | U1.44; R16 pull-down, JP1 to 3V3 | Optional 3.3 V boot-select control |

R28, 10 kΩ, pulls the **MCU side** of R27 / PA10 to 3V3, keeping USART1 RX
idle high when no adapter is attached. The F103 ROM bootloader configures
this input without an internal pull.
Keep USART1 on its default PA9/PA10 pins; the factory bootloader does not use
the application's alternative pin remapping. J5 has no power-output/input pin:
the card remains powered through J2 USB. Do not use RS-232 voltage levels or
a 5 V logic adapter, and do not attach an actively driven adapter to an
unpowered card.

For ordinary debugging, firmware can use USART1 for log output, initially
115200 baud, 8 data bits, no parity, 1 stop bit (8N1). Serial logging is
separate from the USB tester command protocol. It does not coordinate the
two cards. SWD remains available for processor debugging.

### Firmware download through the built-in bootloader

The STM32F103C8T6 system-memory bootloader uses USART1: PA9 TX and PA10 RX.
Enter it with **BOOT0 high and BOOT1/PB2 low at reset**. R17 holds BOOT1 low;
JP1 provides manual BOOT0 selection. These assignments and the boot selection
are specified in [ST AN2606, STM32F10xxx devices / Pattern 1](https://www.st.com/resource/en/application_note/an2606-stm32microcontroller-system-memory-boot-mode-stmicroelectronics.pdf).

1. Connect adapter GND, RX and TX to J5 pins 1, 2 and 3 respectively.
2. Power the card from USB and fit JP1 to pull BOOT0 high.
3. Press/release SW1 (NRST), entering the factory bootloader.
4. Use an AN3155-compatible serial programmer to write and verify the image
   at user-flash address `0x08000000`. Start with 115200 baud, **8E1**; the
   programmer sends the initial `0x7F` autobaud byte. See
   [ST AN3155](https://www.st.com/resource/en/application_note/cd00264342-usart-protocol-used-in-the-stm32-bootloader-stmicroelectronics.pdf).
5. Remove JP1 and press/release SW1 again to boot the application.

This download path works with blank application flash and does not require
application firmware, the external crystal, or an application USB connection.
The F103C8 factory bootloader does not provide USB DFU; J2 supplies power
during serial programming. Muxes remain disabled through R1 while the ROM
bootloader runs, and Q1's base pull-up keeps USB detached.

Pins 4/5 allow a future programming adapter to control reset/boot selection;
they are not needed for manual programming. Keep JP1 open when controlling
BOOT0 externally. Reset control should only pull NRST low or release it;
adapter modem-control polarity/levels must be handled by the adapter, not
assumed to work by wiring RTS/DTR directly.

### J4: SWD

J4 is a simple 1×5 header: 1=3V3 reference, 2=SWDIO, 3=SWCLK, 4=GND,
5=NRST. This custom header is not a standard ARM 10-pin connector.

## 6. PCB and mechanical sketch

- Establish the card outline, thickness, edge-contact pitch, row arrangement,
  insertion depth, keying and contact numbering from a real card/connector.
  J1 is represented in KiCad as seven units of a single logical connector,
  with placeholder pin numbers `L000`–`L099` matching `BP000`–`BP099`.
  No physical backplane footprint or terminal numbering is assigned yet.
- Start with a two-layer board: continuous ground where practical, eight
  SOIC24 muxes along the contact routing, MCU/USB near the accessible edge.
  Reserve clearance so a ground plane cannot contact backplane terminals.
- Keep MEAS and ADC_SENSE short. Place C1 at PA0 and the four stimulus
  resistors near the MCU/root mux. Add test points for GND, USB_5V, 3V3,
  MEAS, ADC_SENSE, MUX_DISABLE and NRST.
- Keep USB D+/D− together over ground, with short stubs. Keep crystal traces
  local and away from the mux address bus.
- Do not add LEDs, fixed ground ties or pull resistors to individual
  backplane contacts. Provide two clip points for known-wire bench checks.
- These simple mux inputs are intended for a disconnected backplane only;
  they do not provide powered-backplane overvoltage protection.

## 7. Prototype acceptance

1. Check the physical contact mapping and verify that no contact is hardwired
   to GND, 3V3 or USB_5V. Check the complete path through both mux stages.
2. Bring up power, clock, SWD, USB attach/detach and unique serial numbers.
   Measure consumption before/after USB enumeration and in suspend.
   Verify a serial download/verify cycle through J5 with JP1 fitted, then
   remove JP1 and reset to check application boot and USART1 debug output.
3. With muxes disabled, measure all five stimulus modes at MEAS. In particular,
   high modes should be near 2.0 V, never an intentional rail-high.
4. Measure receiver BIAS_HIGH/BIAS_LOW baselines with an open fixture.
5. Scan a single known wire, different contact numbers at opposite ends,
   a three-contact join and a deliberately misplaced join. Exercise every
   bank boundary, including logical contacts 95, 96 and 99.
6. Add known series resistances and capacitances. Establish connected/open
   bands, settling times and the uncertain band using actual hardware.
7. Repeat with both polarities, swap board roles, and test reset, USB loss,
   command timeout and moving cards only after both acknowledge SAFE.

Only then freeze classification thresholds, pin labels and PCB dimensions.
