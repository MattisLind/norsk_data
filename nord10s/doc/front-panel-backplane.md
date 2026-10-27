# Front-panel cards: first Verilog backplane pass

The three cards now have separate instances in `nord10s.v`:

| Card | Verilog module | Source drawing |
| --- | --- | --- |
| 1114 D, Panel Transceiver | `panel_transceiver.v` | [1114 PDF](1114-panel-transceiver.pdf), second sheet; original PDF page 133, 4A14 |
| 1115 E/F, Lamp Register | `lamp_register.v` | [1115 PDF](1115-lamp-register.pdf), second sheet; original PDF page 135, 4A15 |
| 1121 C/D, Panel Control | `panel_control.v` | [1121 PDF](1121-panel-control.pdf); original PDF page 143, 4A21 |

This is an **interface and signal-matching pass**, not a working front-panel
implementation. 1114 and 1115 are mostly scaffolding with inactive outputs.
1121 implements the PIL buffers, qualified register-zero strobes, DECODE wire,
and ACTL/ALD read multiplexer. Its button sequencing and PANS/PANC logic remain
TODO. All panel inputs are tied high in the top level; panel outputs are internal
wires awaiting an FPGA adapter. Physical slot positions are not assigned.

The original full drawing collection is
[NORD-10 drawings-Gandalf-OCR.pdf](NORD-10%20drawings-Gandalf-OCR.pdf).
Page numbers here refer to that PDF, starting at 1. The separate
[wiring worksheet](front-panel-interface.md) records physical panel/P1 wiring;
the logical connections below do not establish the cable pinout.

The [2026-10-26 harness tables](front-panel-interface.md#harness-connectors-m1-a17-a18-and-a21)
now supply measured cable routes. Matching terminal patterns associate A17
with 1121, A18 with 1114, and A21 with 1115; these are connector/card
associations inferred from the drawings, not independently verified physical
slot positions. A18's serial/level paths and A21's eighteen lamp paths agree
with the drawings. Most A17 button routes, including complementary phases,
are now resolved. P1 j/k lamp identities and P1 B reaching A17.93 rather than
the drawing's PLOCK terminal 95 remain discrepant; do not encode those cable
assignments in the hardware adapter yet.

## Naming and phases

The existing CPU RTL uses positive logical values: `TRA` asserts high, `IB`
carries logical data, and an inactive IB contributor supplies zero to the
top-level OR. This pass follows that convention on the CPU side. Thus schematic
`PILn_1 -> PLn_0` inverting buffers become a logical `PL = PIL` connection.
The `_0`/`_1` suffixes are retained on **raw panel-side ports**, where the
electrical phase matters. Conversion to actual FPGA I/O belongs in the adapter.

`TR0`, `TR2`, `TR9`, `TR10` are register **selects**, not complete read/write
strobes. Names in the RTL use decimal subscripts; the manuals number registers
in octal. Hence `TR9` selects octal 11 (ACTL), and `TR10` selects octal 12 (ALD).

In particular, **`TRA0` is not another spelling of `TRA_0`**:

| Logical net | Meaning | Drawing evidence |
| --- | --- | --- |
| `TRA` | General internal-register read strobe | 1121 terminal 54; 1114 terminal 55 |
| `TRR` | General internal-register write strobe | 1121 terminal 55; 1115 terminal 43 |
| `TRA0` | `TRA & TR0`, read PANS | 1121 terminal 66/TW5; 1114 terminal 66/TW5 |
| `TRR0` | `TRR & TR0`, write PANC | 1121 terminal 64/TW4; 1114 terminal 64/TW4 |

1121 generates the qualified strobes. These connections are implemented.
The shared `TW` aliases are useful evidence, but terminal numbers and aliases
must be checked per card rather than treated as a universal connector pinout.

## Connected CPU and inter-card signals

“Connected” means the RTL endpoints are wired; it does not mean all logic at
those endpoints is implemented.

| Logical signal | Producer -> consumer | Status / qualification |
| --- | --- | --- |
| `IB[15:0]` | CPU bus -> 1114, 1115, 1121 | Connected as input to each card |
| `IB_panel_transceiver` | 1114 -> IB OR | Connected; contribution held at zero until PANS/OPR logic exists |
| `IB_panel_control` | 1121 -> IB OR | ACTL and ALD reads implemented; other reads contribute zero |
| `TRA`, `TRR` | `timing` -> panel cards | Existing outputs now connected where required |
| `TR0`, `TR2`, `TR9`, `TR10` | `timing` -> panel cards | Existing decode outputs now connected; `timing.IR3_0` also connected to `IR[3:0]` |
| `PIL[3:0]` | `int_regs` -> 1121 and existing `or_logic` | Existing internal PIL register exposed as output, replacing top-level zero tie-off |
| `PL[3:0]` | 1121 -> 1114 and 1115 | Logical PIL copy implemented; schematic terminals 56/58/60/62 on 1121/1114 |
| `RC[3:0]` | 1114 -> 1115; RC3 also -> 1121 | Connected, but held at zero until selector scanning is implemented; RC is distinct from CPU `LEV` |
| `COINC` | 1114 -> 1121 | Terminal 41 on both; connected, held inactive pending comparator/capture logic |
| `OSC` | 1114 -> 1115 | 1114 terminal 51 -> 1115 terminal 50 by signal name; generator TODO |
| `DECODE` | 1121 -> 1115 | 1121 terminal 72/TW8 -> 1115 terminal 39/TW8; logical copy of asserted SWDEC contact |
| `panel_MCL` | 1121 -> CPU `MCL` OR | Reserved, currently inactive. Kept separate from startup/external reset to avoid multiple drivers |
| `IMINH`, `IPFINT` | 1114 pass-throughs | `MINH -> IMINH` and `PFINT -> IPFINT` implemented; upstream producers absent |

1115 **does not drive IB**. Its 74170 banks sample IB and BA for display.
`MCL` on the 1115 module and `reset` on 1121 are FPGA helper ports, not extra
terminals inferred from the drawings.

## Missing producers and unresolved consumers

These nets are explicitly tied to zero in `nord10s.v` until their producers
are implemented. Zero is a temporary simulation value, not a claim about the
original machine's operating state.

| Signal | Panel consumer / evidence | Remaining work |
| --- | --- | --- |
| `BA[17:0]` | 1115 address-bank inputs | Restore memory address bus; do not substitute `MPC`, `R`, or a truncated CPU bus |
| `MR[17:0]` | 1121 lists MR0..17, phase 1, terminals 20..37 | Resolve memory-side/backplane routing; **not** the 32-bit microinstruction `MIR` |
| `PCR[1:0]` | 1114 terminals 52/53 | Implement paging-control register (TRR octal 3) and its outputs |
| `PON`, `ION` | 1114 terminals 39/43; PON on 1121 terminal 38 | Resolve paging/interrupt mode producers; do not alias physical power control to PON |
| `FETCH` | 1115 terminal 41; 1121 terminal 43 | Establish timing/FETCH producer. `ROMRQ` fetches microcode and is not assumed equivalent |
| `MDRY` | 1115 terminal 32; 1121 terminal 40 | Implement memory handshake and panel wired contribution; not `MIRDRY` or `ROMDRY` |
| `DMA`, `BREFRESH`, `BREQ` | 1115 terminals 27/46/24 | Resolve memory/bus-control producers |
| `MINH`, `PFINT` | 1114 terminals 59/63 | MINH cable route: A18.59 → P1 P-V → M1.MM. PFINT cable route: A18.63 → P1 R-U; onward endpoint not supplied. M1.U → lowercase P1 v is a separate net. PSU-side function/voltage and RTL producers remain to be established. IMINH goes onward to 1121 |
| `ALD[15:0]` | 1121 switch banks 1E, 3E, 17E, 19E | Choose desired logical switch setting; currently zero |

The following **outputs** have reserved wires, but their CPU consumers still
need tracing:

| Output | Current treatment | Open question |
| --- | --- | --- |
| `STOP` from 1121 terminal 39 | Held inactive, no CPU consumer connected | Trace STOP into interrupt/control circuitry and determine how OPCOM/OPINT are formed |
| `COINC` | Connected to 1121, held inactive | Implement 1114 comparison/latching before any interrupt-path use |
| `panel_MDRY_hold` | Held inactive, not combined into memory-ready net | 1121's 7417 at terminal 40 can pull MDRY low; integrate with the future memory-ready producer |
| `IPFINT` | Pass-through reserved, no consumer connected | Route through the power-fail/interrupt model |

`OPCOM` and `OPINT` remain the existing CPU placeholders. Neither is assumed
to be a direct alias of STOP or COINC. The existing `microaddressing` module
also has local interrupt placeholders; completing the panel interrupt path
requires work there as well as in `timing` and `int_ctrl`.

1121 terminal 91 is labelled `SWMCL_0 (OSC_0)` on the drawing. This pass reserves
the raw master-clear input separately; it does **not** connect the 1114 oscillator
to master clear merely because of that alias.

## Remaining card behavior

1. Implement 1114 oscillator enables and serial shift/load/capture timing using
   the 1907 timing diagram. Capture the level/register selector and OPR data,
   then enable PANS/OPR IB readback and coincidence generation.
2. Implement 1121 switch conditioning and RUN/STOP/SINGLE/LOAD/RESTART latches,
   PANC writes, PANS status contributions, lamps, and MDRY pull-down behavior.
3. Implement 1115 address/data banks, level capture, display selection and lamp
   persistence. Keep the original BA/IB distinction.
4. Resolve the missing CPU producers and panel interrupt path. The current
   `timing` state machine and interrupt-register reset/readback behavior are
   incomplete independently of this patch; exposing PIL does not fix them.
5. Add physical adapter ports and constraints after connector mapping and
   electrical levels are established in the wiring worksheet.

The FPGA logic should use `clk` with clock enables for the eventual serial
engine, rather than reconstructing the TTL oscillator as a fabric clock.

## Validation of this pass

The three new modules are checked with a SystemVerilog elaborator (pyslang).
The complete top-level hierarchy is also checked against the original baseline
to distinguish integration errors from existing CPU errors. Two existing port
declarations (`prom4k.ROMDRY` and `status.BSHM`) are corrected to `output reg`
because they are assigned procedurally; these caused five baseline elaboration
errors. Duplicate top-level declarations of MPC, BAKL, BCR16 and MCL are also
removed, and IR now has its existing microaddressing producer as its sole driver.
The full hierarchy then elaborates without errors; existing warnings remain.
No hardware or cycle-accurate panel simulation has been performed. Parked signals
and TODO outputs intentionally prevent this pass from being described as a working panel.
