# ND10/S front-panel wiring worksheet

The RTL card boundaries and tentative CPU/backplane connections are recorded
separately in [front-panel-backplane.md](front-panel-backplane.md). Physical
routes are collected below under [harness connectors](#harness-connectors-m1-a17-a18-and-a21);
[discrepancies and open questions](#harness-discrepancies-and-open-questions)
retain conflicts between drawing readings and reported wiring.

Working transcription, updated 2026-10-26. Use this as a worksheet for tracing
the actual panel and cables. It combines schematic readings with Mattis's
reported physical wiring observations; the assistant has not independently
measured the hardware. The rectangular control buttons and key switch use the
separate 56-pole connector P1, rather than PCB 1907's connector.

## Sources and notation

Source: [NORD-10 drawings-Gandalf-OCR.pdf](NORD-10%20drawings-Gandalf-OCR.pdf).
Page numbers below are **PDF viewer page numbers, starting at 1**.

| Board | Drawing | PDF page | Drawing reference | Revisions on sheet |
| --- | --- | --- | --- | --- |
| 1907 | Operator's Panel | 252 | 7B16 | B, C |
| 1114 | Panel Transceiver | 133; alternative on 132 | 4A14 | D; B/C on 132 |
| 1115 | Lamp Register | 135; alternative on 134 | 4A15 | E/F; D on 134 |
| 1121 | Panel Control | 143 | 4A21 | C, D |

The panel illustration in ND-06.009.01, section I.5, PDF page 81, supplies the
physical button names. The circuit sheets supply the electrical signal names.
Mattis supplied the initial P1 wiring observations on 2026-10-22 and the
[START/key-switch sketch](Power_KeyLock_Schematic.jpg) with clarifications on
2026-10-23. The sketch calls the red button POWER; the agreed name here is
**START**, meaning the unlabelled red button in the panel's POWER section.
**The sketch supersedes the earlier START s-to-t make-contact description.**
**The apparent P1 C-L connection needs checking, and the previous DECODE ADDRESS
contact/lamp assignments are now provisional.** The fitted key switch is a
replacement: its actual LOCKED/UNLOCKED positions remain unverified.
Mattis supplied M1, P1-to-A17, A18 and A21 cable traces on 2026-10-26. These
establish measured routes separately from the schematic signal interpretations.
**The apparent C-L join and DECODE ADDRESS wiring remain under review;** the new
traces do not by themselves establish the replacement key switch's positions.

- `D`: directly read from a drawing. `M`: physical wiring reported by Mattis.
  `I`: inferred connection or physical function. `?`: unknown or needs
  verification. `NC`: explicitly reported unconnected. Unknown does **not** mean NC.
- `WL0_0` means data lamp bit 0, schematic logic-phase suffix 0. `WL20_0` is
  a different signal. Preserve the suffixes; do not interpret them as pin numbers.
- Lowercase `a`/`c` labels are the **1907 drawing** row names. For the new
  hardware traces, retain Mattis's provisional **a/b** convention: bare `8`
  means top-row `a8`; `8b` means bottom-row `b8`. Matching bottom-row `b`
  positions to drawing row `c` is an inference, not a confirmed connector view.
- Bare card-terminal numbers below are the **circled terminal references** on
  the 1114/1115/1121 drawings, not IC pin numbers and not 1907 contact numbers.
- `PB0` etc. are the parenthesized labels on the **1121** drawing. They are not
  established physical pin numbers on the separate button connector.
- P1 contact labels are **case-sensitive**: `J` and `j`, `K` and `k`, etc. are
  different contacts. They are also unrelated to 1907 contact labels such as `a7`.
- A matching signal name gives an expected endpoint (`I`). It does not establish
  the intervening cable/backplane path. Fill in `Cable / colour / result` after
  tracing it. Rows marked `M` have a reported panel-end observation; inferred
  connections to the original interface cards remain to be verified unless a
  reported A17/A18/A21 route is explicitly given.
- `A17.91` means connector A17, contact 91. `M1.j` and `P1.j` are different
  connectors; case remains significant. A blank or omitted endpoint in the
  new lists means **not supplied**, not NC. Wire colours do not establish PSU
  voltage or polarity.

## 1907 connector: complete contact inventory

The table accounts for all **64 contacts**, sorted **a1–a32, then c1–c32**.
It combines the serial interface, level controls, parallel indicators and
grounds. Directions are relative to the panel. The other end may eventually
be an FPGA adapter replacing the original interface cards.

Checked against drawing **7B16, 1907 revisions B/C** (source PDF page 252):
all **34 labelled connector contacts** are accounted for below: 20 parallel
indicator inputs, five serial-interface contacts, four level-button contacts
and five grounds. The signal names and contact numbers match the drawing.

The other **30 contacts are not shown on this schematic**. They retain **NC**
in the worksheet as requested, with drawing evidence stated separately as
"Not shown on 1907 schematic". **The drawing does not explicitly mark these
contacts NC, so their physical disconnection is not established by this sheet.**
No harness route is supplied for these contacts.
**The +5 V rail is shown on 1907, but its connector feed contact remains
unidentified.**

The sheet shows 74L17/7417 drivers sinking current through LEDs to +5 V.
At the parallel indicator inputs, low lights the corresponding LED. The
serial indicator chain is separate from these parallel data-lamp connections.

| 1907 contact | Signal / status | Direction | Function / drawing evidence | Expected card endpoint (I) | Cable / colour / result |
| --- | --- | --- | --- | --- | --- |
| a1 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| a2 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| a3 | GND | Reference | D: explicit ground symbol below SREG_0 output on 1907; also grounded at 1114 terminal 81 | 1114 terminal 81 | M: A18.81 ↔ Euro a3 (raw `3`); I: row correspondence |
| a4 | WL20_0 | To panel | D: INTERRUPT indicator; active-low LED input | 1114 terminal 95 | M: A18.95 ↔ Euro a4 (raw `4`); I: row correspondence |
| a5 | WL21_0 | To panel | D: PAGING indicator; active-low LED input | 1114 terminal 93 | M: A18.93 ↔ Euro a5 (raw `5`); I: row correspondence |
| a6 | SREG_0 | From panel | D: register-selector serial return, through F 7417; 680 ohm pull-up to +5 V | 1114 terminal 83 | M: A18.83 ↔ Euro a6 (raw `6`); I: row correspondence |
| a7 | SLD_0 | To panel | D: active-low parallel-load strobe; internal LOAD_0 loads the 74L165 inputs | 1114 terminal 79 | M: A18.79 ↔ Euro a7 (raw `7`); I: row correspondence |
| a8 | WL0_0 | To panel | D: Data bit 0; active-low LED input | 1115 terminal 95 | M: A21.95 ↔ Euro a8 (raw `8`); top row provisionally a |
| a9 | WL2_0 | To panel | D: Data bit 2; active-low LED input | 1115 terminal 91 | M: A21.91 ↔ Euro a9 (raw `9`); top row provisionally a |
| a10 | WL1_0 | To panel | D: Data bit 1; active-low LED input | 1115 terminal 93 | M: A21.93 ↔ Euro a10 (raw `10`); top row provisionally a |
| a11 | WL3_0 | To panel | D: Data bit 3; active-low LED input | 1115 terminal 89 | M: A21.89 ↔ Euro a11 (raw `11`); top row provisionally a |
| a12 | WL4_0 | To panel | D: Data bit 4; active-low LED input | 1115 terminal 87 | M: A21.87 ↔ Euro a12 (raw `12`); top row provisionally a |
| a13 | WL5_0 | To panel | D: Data bit 5; active-low LED input | 1115 terminal 85 | M: A21.85 ↔ Euro a13 (raw `13`); top row provisionally a |
| a14 | WL17_0 | To panel | D: Data bit 17 / address extension; active-low LED input | 1115 terminal 61 | M: A21.61 ↔ Euro a14 (raw `14`); top row provisionally a |
| a15 | WL16_0 | To panel | D: Data bit 16 / address extension; active-low LED input | 1115 terminal 63 | M: A21.63 ↔ Euro a15 (raw `15`); top row provisionally a |
| a16 | WL15_0 | To panel | D: Data bit 15; active-low LED input | 1115 terminal 65 | M: A21.65 ↔ Euro a16 (raw `16`); top row provisionally a |
| a17 | WL13_0 | To panel | D: Data bit 13; active-low LED input | 1115 terminal 69 | M: A21.69 ↔ Euro a17 (raw `17`); top row provisionally a |
| a18 | WL14_0 | To panel | D: Data bit 14; active-low LED input | 1115 terminal 67 | M: A21.67 ↔ Euro a18 (raw `18`); top row provisionally a |
| a19 | WL12_0 | To panel | D: Data bit 12; active-low LED input | 1115 terminal 71 | M: A21.71 ↔ Euro a19 (raw `19`); top row provisionally a |
| a20 | WDOWN_1 | From panel | D: one contact of level-down changeover button; common shown grounded | 1114 terminal 71 | M: A18.71 ↔ Euro a20 (raw `20`); I: row correspondence |
| a21 | WDOWN_0 | From panel | D: other contact of level-down button; common shown grounded | 1114 terminal 69 | M: A18.69 ↔ Euro a21 (raw `21`); I: row correspondence |
| a22 | WUP_1 | From panel | D: one contact of level-up changeover button; common shown grounded | 1114 terminal 67 | M: A18.67 ↔ Euro a22 (raw `22`); I: row correspondence |
| a23 | WUP_0 | From panel | D: other contact of level-up button; common shown grounded | 1114 terminal 65 | M: A18.65 ↔ Euro a23 (raw `23`); I: row correspondence |
| a24 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| a25 | WL11_0 | To panel | D: Data bit 11; active-low LED input | 1115 terminal 73 | M: A21.73 ↔ Euro a25 (raw `25`); top row provisionally a |
| a26 | WL10_0 | To panel | D: Data bit 10; active-low LED input | 1115 terminal 75 | M: A21.75 ↔ Euro a26 (raw `26`); top row provisionally a |
| a27 | WL9_0 | To panel | D: Data bit 9; active-low LED input | 1115 terminal 77 | M: A21.77 ↔ Euro a27 (raw `27`); top row provisionally a |
| a28 | WL7_0 | To panel | D: Data bit 7; active-low LED input | 1115 terminal 81 | M: A21.81 ↔ Euro a28 (raw `28`); top row provisionally a |
| a29 | WL8_0 | To panel | D: Data bit 8; active-low LED input | 1115 terminal 79 | M: A21.79 ↔ Euro a29 (raw `29`); top row provisionally a |
| a30 | WL6_0 | To panel | D: Data bit 6; active-low LED input | 1115 terminal 83 | M: A21.83 ↔ Euro a30 (raw `30`); top row provisionally a |
| a31 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| a32 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c1 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c2 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c3 | GND | Reference | D: explicit ground symbol near SLD input | 1114 terminal 77 | M: A18.77 ↔ Euro b3 (raw `3b`); I: row correspondence |
| c4 | GND | Reference | D: explicit ground symbol near SOUT input | 1114 terminal 73 | M: A18.73 ↔ Euro b4 (raw `4b`); I: row correspondence |
| c5 | GND | Reference | D: explicit ground symbol near SW return | 1114 terminal 85 | M: A18.85 ↔ Euro b5 (raw `5b`); I: row correspondence |
| c6 | SW_0 | From panel | D: data-switch serial return, through F 7417; 680 ohm pull-up to +5 V | 1114 terminal 87 | M: A18.87 ↔ Euro b6 (raw `6b`); I: row correspondence |
| c7 | SCL_1 | To panel | D: serial clock; two G inverters produce internal CLOCK_1 | 1114 terminal 75 | M: A18.75 ↔ Euro b7 (raw `7b`); I: row correspondence |
| c8 | SOUT_0 | To panel | D: serial indicator/display data into H/S 74L164 chain, through G inverter | 1114 terminal 91 | M: A18.91 ↔ Euro b8 (raw `8b`); I: row correspondence |
| c9 | GND | Reference | D: explicit ground symbol near SOUT input | 1114 terminal 89 | M: A18.89 ↔ Euro b9 (raw `9b`); I: row correspondence |
| c10 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c11 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c12 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c13 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c14 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c15 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c16 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c17 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c18 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c19 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c20 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c21 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c22 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c23 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c24 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c25 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c26 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c27 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c28 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c29 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c30 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c31 | NC | — | Not shown on 1907 schematic | — | Not supplied |
| c32 | NC | — | Not shown on 1907 schematic | — | Not supplied |

The A18 traces identify all four level-button paths. Their physical NO/NC
action is still to be checked; the phase suffixes alone do not establish it.

1114 shows grounded terminals next to the serial lines: 73 next to SCL,
77 next to SLD, 81 next to SREG, 85 next to SW, and 89 next to SOUT. The
reported A18 routes to panel grounds are included above; the hardware row
identity and connector viewing orientation remain to be verified.

## Separate rectangular-button connector

### P1 physical wiring reported by Mattis

P1 is a rectangular 56-pole connector. The white rectangular buttons each have
an **SPDT switch and a lamp**, although not all lamps or switch contacts are
wired. They are momentary except **DECODE ADDRESS**, which is
**maintained (non-momentary)**. Preserve its state rather than treating it as
an automatically released button.

P1 **A is ground/common**. The following pairs are joined directly inside
the connector (M): **A-E, C-H, P-V, R-U, S-X and T-W**. These are permanent
connector links, distinct from the switched contacts described below. The
new A18/M1 routes for P/V, R/U, S/X and T/W are derived in the harness section.
**B is a white wire to the key
switch; C is a black wire to the key switch**. The key switch has **two make
and two break contacts, arranged as two changeover pairs**, detailed below.
Its physical LOCKED/UNLOCKED positions remain to be verified because the
original key switch was missing and a replacement was fitted.
**START is the unlabelled red button in the POWER section**, not an additional
control. Connector viewing orientation is not yet recorded.

P1 lowercase **v** is the red/brown wire shared by a START make contact and the
upper key-switch common through a red wire. It is distinct from uppercase V,
which is linked to P inside the connector. The sketch also appears to join
**P1 L (pink/brown) directly to C (black)**. Mattis agrees this appears to be
the case, but will recheck DECODE ADDRESS. **Treat C-L as provisional**, and do not
claim it is an additional link inside the connector. **The 2026-10-26 traces put
C at A17.96 and L at A17.81 (the drawing's SWDEC_0 input), so the apparent
permanent C-L join needs specific confirmation.**

| Control | Action | Make contact(s) at P1 | Break contact at P1 | Lamp connection at P1 | Remaining check |
| --- | --- | --- | --- | --- | --- |
| DECODE ADDRESS | Maintained SPDT | **Actual contact wiring under review; L cable reaches A17.81 / SWDEC_0** | ? | **?; previously reported L-A, now under review** | **Retrace switch common, both contacts and lamp after apparent C-L join** |
| MASTER CLEAR | Momentary SPDT | D → A17.91 / SWMCL_0 | ? | **Earlier M: j-A; new j → A17.59 / LOAD lamp conflicts** | **Recheck j/k lamps; break contact unknown** |
| RESTART | Momentary SPDT | F → A17.89 / SWREST_0 | J → A17.87 / SWREST_1 | NC | Phase resolved by new route and drawing |
| LOAD | Momentary SPDT | K → A17.85 / SWLOAD_0 | M → A17.83 / SWLOAD_1 | **Earlier M: k-A; new k → A17.57 / MASTER CLEAR lamp conflicts** | **Recheck j/k lamps** |
| SET ADDRESS | Momentary SPDT | N | NC | NC | Card-end continuity |
| DEPOSIT | Momentary SPDT | Y | NC | NC | Card-end continuity |
| ENTER REGISTER | Momentary SPDT | a | NC | NC | Card-end continuity |
| SINGLE INSTR. | Momentary SPDT | Z → A17.73 / SWSING_0 | b → A17.71 / SWSING_1 | NC | Phase resolved by new route and drawing |
| CONTINUE | Momentary SPDT | c → A17.69 / SWCON_0 | e → A17.67 / SWCON_1 | f-A; f → A17.63 / SWLCON_0 | Phase resolved by new route and drawing |
| STOP | Momentary SPDT | d | NC | Between h and A | Card-end continuity |
| START (red button) | Two make contacts and one break contact; drawn released/OFF | Lamp make: C to lamp; other make: v to t | s to brown wire leading to upper key-switch contact | Green return to A; black terminal through START lamp make to C | Physical terminals, actuation mechanism and external power-control paths |
| Key switch | Two changeover pairs | Pair 1: C to B; pair 2: v to grey/t | Pair 1: C to button-contact common; pair 2: v to brown | No key-switch lamp identified | Actual key-position labels and external signal functions |

The MASTER CLEAR, LOAD, CONTINUE, STOP and START lamps return to **A**.
START's green lamp-return endpoint is now established by the sketch; its black
terminal reaches C through a START make contact. **DECODE ADDRESS lamp wiring
must be rechecked.** Previously reported NC lamps remain NC. Lamp voltage and
current ratings remain unknown.

### START switch and lamp connections

The following is read from the new sketch, with START released/OFF as confirmed
by Mattis. Contact numbers are worksheet identifiers, not stamped terminals.
**The earlier statement that a START make contact directly joins s and t is
superseded: the sketch shows a v-t make and a separate s-brown break.**
**Any earlier DECODE ADDRESS common-to-START assignment awaits retracing.**

| START element | One side | Other side | State drawn / outstanding check |
| --- | --- | --- | --- |
| Make contact 1 (lamp) | **Black C wire; apparent pink/brown branch to L** | Black lamp terminal | Open with START released; close on actuation |
| Make contact 2 | P1 v, red/brown; red branch to key pair 2 common | Grey wire, joined to P1 t by white/blue lead | Open with START released; close on actuation |
| Break contact | P1 s, grey/blue | Brown wire to key pair 2 break | Closed with START released; opens on actuation |
| Lamp | Black terminal through make 1 to C | Green return to P1 A | Pressing START completes the C-lamp-A path; illumination depends on external drive at C |

Crossings without junctions in the sketch are read as separate wires; in
particular the white/blue t lead crosses the brown wire without joining it.
This records contact connectivity, not voltage, current direction or the
external meaning of s/t/v. Released/OFF is the stated button position, not a
verified description of the whole computer's power state.

### Key-switch contact pairs and provisional states

Pair numbers retain the earlier worksheet convention: pair 1 is the lower
button-common circuit in the sketch; pair 2 is the upper START circuit.
The sketch's contact positions are intended to represent UNLOCKED, but the
replacement switch's physical key positions have not yet been verified.

| Key-switch element | Connection from sketch | Wire colour | Remaining check |
| --- | --- | --- | --- |
| Pair 1 common | **P1 C; confirmed connector link C-H; apparent harness join to L** | Black | **Verify C-L and card-end paths** |
| Pair 1 make, open as drawn | P1 B | White | Confirm physical key position that closes B-C |
| Pair 1 break, closed as drawn | Other buttons' common wire | Black | Exact scope of bus and physical key-position behavior |
| Pair 2 common | P1 v and START make 2 common | Red to START; red/brown at v | External power-control endpoint |
| Pair 2 make, open as drawn | START make 2 other side and P1 t | Grey; white/blue at t | Confirm physical key position that closes v-t |
| Pair 2 break, closed as drawn | START break other side | Brown; grey/blue at s beyond START break | Confirm physical key-position behavior |

The **button-contact common bus** is switched by pair 1. It is not assumed to
be permanently joined to ground/lamp common A/E. The drawing gives C as the
common of this key pair; it does not establish C's voltage or external role.

For continuity checking, call the key state **K0** when contacts are as drawn,
and **K1** when both pairs are changed over. K0 is *provisionally UNLOCKED*;
K1 is *provisionally LOCKED*. The table assumes both pairs change together.

| Key state | START position | s-v path | t-v path | Other buttons' common to C | B-C path |
| --- | --- | --- | --- | --- | --- |
| K0, as drawn | Released/OFF | Closed through START break and brown key contact | Open | Closed | Open |
| K0, as drawn | Actuated | Open | Closed through START make 2 | Closed | Open |
| K1, changed over | Released/OFF | Open | Closed through grey key contact | Open | Closed |
| K1, changed over | Actuated | Open | Closed through key and START contacts | Open | Closed |

These are **inferences from the sketch**, not measured continuity results.
In K1, START no longer changes the s-v/t-v connections, and the other buttons'
common is disconnected from C. This is consistent with the intended lockout.
The START lamp contact can still close in either key position; its actual
illumination remains dependent on the external circuit.

**Intended behavior reported by Mattis:** LOCKED should prevent the other panel
buttons from taking effect and prevent powering down an already running
computer; UNLOCKED should allow those functions. On 2026-10-23 Mattis planned
a weekend check of the replacement switch; its position/lockout results have
not yet been reported. No FPGA key-state polarity or power-down logic is
derived from the provisional labels yet.

### P1 contact inventory

The rows follow the supplied contact sequence; this is not a claim about the
physical row/column arrangement or connector mating view. Mattis reports
contacts through `v`, with `l, m, n, p, r, u` unconnected, and all positions from
`w` through `NN` unconnected. The table records wiring status, not whether an
unconnected position has a metal contact fitted.

| P1 label | Panel-end assignment / status | Evidence | Wire colour / A17, A18 or M1 route |
| --- | --- | --- | --- |
| A | Ground / lamp common; returns for MASTER CLEAR, LOAD, CONTINUE, STOP and START; joined to E in connector | M, D sketch; M 2026-10-26 | M: A17.98, grön/green; START return green |
| B | Key-switch pair 1 make | M; M 2026-10-26 | **M: A17.93; white. Drawing PLOCK is terminal 95: discrepancy** |
| C | **Key-switch pair 1 common and START lamp-make feed; joined to H in connector; apparent direct join to L** | **M, D sketch; C-L provisional; M 2026-10-26** | **M: A17.96; black. Apparent C-L join would also join A17.96 and A17.81; verify** |
| D | MASTER CLEAR make | M; M 2026-10-26 | M: A17.91; schematic signal in A17 table below |
| E | Ground / common via connector link to A | M | No separate endpoint supplied; I: reaches A17.98 through confirmed A-E strap |
| F | RESTART make | M; M 2026-10-26 | M: A17.89; schematic signal in A17 table below |
| H | Key-switch pair 1 common via connector link to C | M | No separate endpoint supplied; I: reaches A17.96 through confirmed C-H strap |
| J | RESTART break | M; M 2026-10-26 | M: A17.87; schematic signal in A17 table below |
| K | LOAD make | M; M 2026-10-26 | M: A17.85; schematic signal in A17 table below |
| L | **Apparent direct join to C in sketch; former DECODE ADDRESS make/lamp assignment under review** | D sketch, M provisional; M 2026-10-26 | **M: A17.81 (D: SWDEC_0); pink/brown from sketch. Apparent C-L join and switch wiring unresolved** |
| M | LOAD break | M; M 2026-10-26 | M: A17.83; schematic signal in A17 table below |
| N | SET ADDRESS make | M; M 2026-10-26 | M: A17.79; schematic signal in A17 table below |
| P | Joined directly to V inside connector; A18.59 / M1.MM route | M; M 2026-10-26 | M: A18.59; I: P-V strap reaches M1.MM; drawing identifies MINH_0 |
| R | Joined directly to U inside connector; A18.63 / PFINT_0 route | M; M 2026-10-26 | M: A18.63; I: R-U strap. Onward endpoint beyond U not supplied; no assumed join to M1.U |
| S | Joined directly to X inside connector; A18.57 / M1.Y route | M; M 2026-10-26 | M: A18.57; I: S-X strap reaches M1.Y; drawing shows ground |
| T | Joined directly to W inside connector; A18.61 / M1.X route | M; M 2026-10-26 | M: A18.61; I: T-W strap reaches M1.X; drawing shows ground |
| U | Joined directly to R inside connector; A18.63 route via R | M | No separate P1-list endpoint; I: R-U strap reaches A18.63 / PFINT_0. Distinct from M1.U |
| V | Joined directly to P inside connector; M1.MM endpoint reported | M; M 2026-10-26 | M: M1.MM ↔ P1 V; I: V-P strap reaches A18.59 / MINH_0 |
| W | Joined directly to T inside connector; M1.X endpoint reported | M; M 2026-10-26 | M: M1.X ↔ P1 W; I: W-T strap reaches A18.61 / GND |
| X | Joined directly to S inside connector; M1.Y and auxiliary memory-plug branch reported | M; M 2026-10-26 | M: M1.Y ↔ P1 X; I: X-S strap reaches A18.57 / GND. Extra memory-plug branch annotated `94`; exact numbering unresolved |
| Y | DEPOSIT make; auxiliary memory-plug branch reported | M; M 2026-10-26 | M: A17.77 / SWDEP_0; extra memory-plug branch annotated `93`; exact numbering unresolved |
| Z | SINGLE INSTR. make | M; M 2026-10-26 | M: A17.73; schematic signal in A17 table below |
| a | ENTER REGISTER make | M; M 2026-10-26 | M: A17.75; schematic signal in A17 table below |
| b | SINGLE INSTR. break | M; M 2026-10-26 | M: A17.71; schematic signal in A17 table below |
| c | CONTINUE make | M; M 2026-10-26 | M: A17.69; schematic signal in A17 table below |
| d | STOP make | M; M 2026-10-26 | M: A17.65; schematic signal in A17 table below |
| e | CONTINUE break | M; M 2026-10-26 | M: A17.67; schematic signal in A17 table below |
| f | CONTINUE lamp; other terminal A | M; M 2026-10-26 | M: A17.63; schematic signal in A17 table below |
| h | STOP lamp; other terminal A | M; M 2026-10-26 | M: A17.61; schematic signal in A17 table below |
| j | MASTER CLEAR lamp; other terminal A | M; M 2026-10-26 | **M: A17.59 / SWLLOAD_0; conflicts with earlier MASTER CLEAR lamp observation** |
| k | LOAD lamp; other terminal A | M; M 2026-10-26 | **M: A17.57 / SWLMCL_0; conflicts with earlier LOAD lamp observation** |
| l | NC | M | NC |
| m | NC | M | NC |
| n | NC | M | NC |
| p | NC | M | NC |
| r | NC | M | NC |
| s | START break contact to brown wire toward key pair 2 break | D sketch; M 2026-10-26 | M: M1.j ↔ P1 s; grey/blue from sketch; START break path |
| t | START make 2 other side and key pair 2 make, joined by grey wire | D sketch; M 2026-10-26 | M: M1.NN ↔ P1 t; white/blue from sketch; START/key make path |
| u | NC | M | NC |
| v | START make 2 common and key pair 2 common via red wire | M, D sketch; M 2026-10-26 | M: M1.U ↔ P1 v; red/brown. No measured join to uppercase P1 U / A18.63 |
| w | NC | M | NC |
| x | NC | M | NC |
| y | NC | M | NC |
| z | NC | M | NC |
| AA | NC | M | NC |
| BB | NC | M | NC |
| CC | NC | M | NC |
| DD | NC | M | NC |
| EE | NC | M | NC |
| FF | NC | M | NC |
| HH | NC | M | NC |
| JJ | NC | M | NC |
| KK | NC | M | NC |
| LL | NC | M | NC |
| MM | NC | M | NC |
| NN | NC | M | NC |

### Cross-reference to 1121: cable routes and drawing interpretations

1121, PDF page 143, supplies the signal names below. The new A17 routes
establish the P1 endpoints for most signals, including complementary button
phases. Signal names remain drawing interpretations of those measured routes;
card revision and placement are not independently verified. Earlier physical
button/lamp observations are retained where they conflict with these routes.

| Physical control / lamp | Signal on 1121 | 1121 terminal | Drawing alias | Direction | Evidence / interpretation | Physical connector / pin | Cable / colour / result |
| --- | --- | --- | --- | --- | --- | --- | --- |
| MASTER CLEAR lamp | SWLMCL_0 | 57 | PB0_0 | To panel | **D: SWLMCL_0 at 57; earlier M: MASTER CLEAR lamp on j. New harness instead puts k at 57; unresolved swap** | **P1 k → A17.57 (new M); earlier physical lamp reported j** | **Resolve j/k lamps** |
| LOAD lamp | SWLLOAD_0 | 59 | PB1_0 | To panel | **D: SWLLOAD_0 at 59; earlier M: LOAD lamp on k. New harness instead puts j at 59; unresolved swap** | **P1 j → A17.59 (new M); earlier physical lamp reported k** | **Resolve j/k lamps** |
| STOP lamp | SWLSTOP_0 | 61 | PB2_0 | To panel | D: 8C 7417 output; I: stopped button lamp | P1 h → A17.61; return A | M route matches D signal |
| CONTINUE lamp | SWLCON_0 | 63 | PB3_0 | To panel | D: 8C 7417 output; I: running/continue button lamp | P1 f → A17.63; return A | M route matches D signal |
| STOP switch | SWSTOP_0 | 65 | PB4_0 | From panel | D: pulled-up, filtered input; I: stop request | P1 d make → A17.65 | M route matches D signal |
| CONTINUE switch, phase 1 | SWCON_1 | 67 | PB5_1 | From panel | D: pulled-up input to 14A 74120 | P1 e break → A17.67 | Phase resolved by M route + D |
| CONTINUE switch, phase 0 | SWCON_0 | 69 | PB6_0 | From panel | D: second pulled-up input to 14A 74120 | P1 c make → A17.69 | Phase resolved by M route + D |
| SINGLE INSTR switch, phase 1 | SWSING_1 | 71 | PB7_1 | From panel | D: pulled-up input to 14A 74120 | P1 b break → A17.71 | Phase resolved by M route + D |
| SINGLE INSTR switch, phase 0 | SWSING_0 | 73 | PB8_0 | From panel | D: second pulled-up input to 14A 74120 | P1 Z make → A17.73 | Phase resolved by M route + D |
| ENTER REG switch | SWENT_0 | 75 | PB9_0 | From panel | D: pulled-up input; I: enter register | P1 a make → A17.75 | M route matches D signal |
| DEPOSIT switch | SWDEP_0 | 77 | PB10_0 | From panel | D: pulled-up input; I: deposit memory | P1 Y make → A17.77 | Extra memory-plug branch annotated `93`; exact numbering unresolved |
| SET ADR switch | SWSETA_0 | 79 | PB11_0 | From panel | D: pulled-up input; I: set examine address | P1 N make → A17.79 | M route matches D signal |
| DECODE ADR switch | SWDEC_0 | 81 | PB12_0 | From panel | D: pulled-up input; also feeds DECODE_0 | **P1 L → A17.81; actual switch/lamp and apparent C-L join under review** | Cable endpoint established; retrace panel switch |
| DECODE ADR lamp | ? | ? | ? | To panel | **Earlier shared make/lamp and L-A report awaits recheck** | ? | Retrace lamp |
| LOAD switch, phase 1 | SWLOAD_1 | 83 | PB13_1 | From panel | D: pulled-up input to 16A 74120 | P1 M break → A17.83 | Phase resolved by M route + D |
| LOAD switch, phase 0 | SWLOAD_0 | 85 | PB14_0 | From panel | D: second pulled-up input to 16A 74120 | P1 K make → A17.85 | Phase resolved by M route + D |
| RESTART switch, phase 1 | SWREST_1 | 87 | PB15_1 | From panel | D: pulled-up input to 16A 74120 | P1 J break → A17.87 | Phase resolved by M route + D |
| RESTART-related complementary input | SWREST_0 | 89 | C.C. | From panel | D: SWREST_0 labelled C.C.; new cable trace supplies a P1 endpoint | P1 F make → A17.89 | Phase resolved by M route + D; C.C. label retained |
| MASTER CLEAR switch | SWMCL_0 | 91 | Parenthesized OSC_0? | From panel | D: filtered input to 16B 7417, then MSTOP logic; parenthesized alias needs checking | P1 D make → A17.91 | M route matches D signal |
| Key switch / panel lock | **PLOCK_0** | 95 | SSTOP_0 | From panel | **D: PLOCK_0 at terminal 95. M: white key wire P1 B reaches A17.93, not 95; unresolved** | **P1 B → A17.93; A17.95 endpoint not supplied** | **Do not equate 93 with 95** |
| Switch-contact common(s) | ? | ? | ? | Reference | **M/D sketch: other buttons' common through key pair 1 break to C; DECODE common under review** | **C/H; apparent join to L provisional; not assumed A/E** | Black |
| Button-lamp common / return | ? | ? | ? | Reference | **M/D sketch: MASTER CLEAR, LOAD, CONTINUE, STOP and START return to A; DECODE return under review** | P1 A/E | START return green |
| START make contact 1 / lamp circuit | ? | ? | ? | ? | D sketch: START make between C and black lamp terminal; lamp green return A | **P1 C and A; apparent C-L branch provisional** | Black / green |
| START make contact 2 | ? | ? | ? | ? | **D sketch: v-t make; replaces earlier s-t report** | P1 v → M1.U; P1 t → M1.NN | D sketch: make v-t; M external routes |
| START break contact | ? | ? | ? | ? | D sketch: s through START break to brown key pair 2 break | P1 s → M1.j; key common v → M1.U | D sketch: s-brown-key-v; M external routes |
| Key-switch pair 1 / button-contact common | ? | ? | ? | ? | M/D sketch: common C/H; make B; break other buttons' common; physical key positions unverified | P1 B and C/H; bus endpoint ? | Black / white |
| Key-switch pair 2 / START control | ? | ? | ? | ? | D sketch: common v via red; make grey/t; break brown/s through START break | P1 v, t, s; external power-control paths ? | See contact table |

The control called POWER in the hand sketch is the same red button called
START here. Its s/t/v circuit now has M1 endpoints. **PLOCK_0 remains unverified
because the traced B endpoint is A17.93 rather than the drawing's terminal 95.**

The 7417 lamp outputs identify current-sinking outputs; they do not establish
the voltage/current rating of the rectangular-button lamps. Keep those lamp
circuits distinct from the 1907 LED circuits until measured.

## Harness connectors: M1, A17, A18 and A21

The following cable traces were reported by Mattis on **2026-10-26**. Tables
separate reported connectivity (`M`) from signal identification using drawings
(`D`/`I`). Matching terminal patterns associate **A17 with 1121**, **A18 with
1114**, and **A21 with 1115**. These are inferred card/connector associations;
no physical slot ordering or connector mating view is claimed.

P1 routes are also integrated into the complete contact inventory above.
All endpoint labels are connector-qualified: `P1 V` is distinct from `M1 V`,
and either is distinct from lowercase `v`.

### M1: PSU-side 56-pole connector

A Swedish colour word is a wire colour; a single/double-letter token is the
corresponding P1 contact. Preserve colour-only entries without assigning a
voltage: `gul` = yellow, `lila` = purple, `svart` = black, `orange` = orange,
`grå` = grey, `grön` = green. The PSU has several voltage rails; colour alone
is not a measurement of rail voltage or polarity. Unlisted M1 contacts have
no supplied assignment, not an NC designation.

| M1 contact | Raw token (M) | Interpretation | Reciprocal / remaining work |
| --- | --- | --- | --- |
| A | gul | Yellow | PSU voltage/function and other endpoint not supplied |
| E | gul | Yellow | PSU voltage/function and other endpoint not supplied |
| P | lila | Purple | PSU voltage/function and other endpoint not supplied |
| S | svart | Black | PSU voltage/function and other endpoint not supplied |
| T | svart | Black | PSU voltage/function and other endpoint not supplied |
| U | v | P1 v | Confirmed by P1 v → M1 U in the new P1 list |
| V | svart | Black | PSU voltage/function and other endpoint not supplied |
| W | svart | Black | PSU voltage/function and other endpoint not supplied |
| X | W | P1 W | Confirmed by P1 W → M1 X in the new P1 list |
| Y | X | P1 X | Confirmed by P1 X → M1 Y in the new P1 list |
| Z | svart | Black | PSU voltage/function and other endpoint not supplied |
| b | orange | Orange | PSU voltage/function and other endpoint not supplied |
| d | grå | Grey | PSU voltage/function and other endpoint not supplied |
| j | s | P1 s | Confirmed by P1 s → M1 j in the new P1 list |
| n | grön | Green | PSU voltage/function and other endpoint not supplied |
| s | grön | Green | PSU voltage/function and other endpoint not supplied |
| t | svart | Black | PSU voltage/function and other endpoint not supplied |
| y | svart | Black | PSU voltage/function and other endpoint not supplied |
| MM | V | P1 V | Confirmed by P1 V → M1 MM in the new P1 list |
| NN | t | P1 t | Confirmed by P1 t → M1 NN in the new P1 list |

All **six** M1-to-P1 lettered links are reciprocal in the two supplied lists:
`M1.U ↔ P1 v`, `M1.X ↔ P1 W`, `M1.Y ↔ P1 X`, `M1.j ↔ P1 s`,
`M1.MM ↔ P1 V`, `M1.NN ↔ P1 t`.

### A17: direct P1 routes and 1121 signal names

Numbers after a P1 label refer to A17. Blank P1 entries supplied for
E, H, P, R, S, T and U are retained as **no separate destination supplied**;
connector straps and A18 routes establish the onward paths shown elsewhere.
Lettered M1 endpoints for V, W, X, s, t and v are in the M1 table above.

| P1 contact | A17 contact (M) | Earlier panel-end observation | 1121 drawing signal / interpretation (D/I) |
| --- | --- | --- | --- |
| A | 98 | Ground/lamp return; grön/green | Ground inferred from panel return; A17 power-contact function not independently measured |
| B | 93 | Key pair 1 make; white | **No terminal-93 signal established on the 1121 sheet; PLOCK_0 is at 95** |
| C | 96 | Key pair 1 common; black | A17 power/reference contact; voltage/function not supplied |
| D | 91 | MASTER CLEAR make | SWMCL_0 / master clear |
| F | 89 | RESTART make | SWREST_0 / complementary restart, C.C. |
| J | 87 | RESTART break | SWREST_1 / restart |
| K | 85 | LOAD make | SWLOAD_0 / load |
| L | 81 | **DECODE wiring under review; apparent C-L join** | SWDEC_0 / decode input; switch wiring unresolved |
| M | 83 | LOAD break | SWLOAD_1 / complementary load |
| N | 79 | SET ADDRESS make | SWSETA_0 / set address |
| Y | 77 | DEPOSIT make | SWDEP_0 / deposit; raw `M1 plugg 93` denotes extra memory-plug branch; exact numbering unresolved |
| Z | 73 | SINGLE INSTR. make | SWSING_0 / single instruction |
| a | 75 | ENTER REGISTER make | SWENT_0 / enter register |
| b | 71 | SINGLE INSTR. break | SWSING_1 / complementary single instruction |
| c | 69 | CONTINUE make | SWCON_0 / continue |
| d | 65 | STOP make | SWSTOP_0 / stop |
| e | 67 | CONTINUE break | SWCON_1 / complementary continue |
| f | 63 | CONTINUE lamp | SWLCON_0 / CONTINUE lamp |
| h | 61 | STOP lamp | SWLSTOP_0 / STOP lamp |
| j | 59 | MASTER CLEAR lamp (earlier M) | **SWLLOAD_0 / LOAD lamp: conflicts with earlier j observation** |
| k | 57 | LOAD lamp (earlier M) | **SWLMCL_0 / MASTER CLEAR lamp: conflicts with earlier k observation** |

**A17.74:** Mattis reports `74 A17 går till egen plugg??` (goes to a separate
plug?). The 1121 sheet labels terminal 74 **IMINH_0 / TW9_0**. The separate
plug, its pinout and actual onward path are unidentified. **A17.95's cable
endpoint was not supplied; do not replace the reported A17.93 route with 95.**

### Auxiliary plug to the memory system

Mattis clarifies that `M1 plugg 94` and `M1 plugg 93` denote an **additional
small plug intended for the memory system**, connected to the **multiport
memory in the current machine**. Its purpose is not yet known. It is not a
numeric contact assignment on the lettered PSU connector M1. Use **MEM-AUX**
as a worksheet-only name until its actual designation is established.

| Reported branch | Raw annotation retained | Known destination | Remaining identification |
| --- | --- | --- | --- |
| P1 X, also connected to PSU M1.Y and via X-S to A18.57 / ground | `M1 plugg 94` | MEM-AUX → multiport memory | What 94 numbers; plug contacts; exact memory-side terminal/function |
| P1 Y, also connected to A17.77 / SWDEP_0 | `M1 plugg 93` | MEM-AUX → multiport memory | What 93 numbers; plug contacts; exact memory-side terminal/function |

Do not infer a join between X and Y: they remain separate branches through the
plug. Whether A17.74's separately mentioned plug is this same MEM-AUX plug
is also unresolved. A ground and a DEPOSIT-related branch suggest a control
connection (I), but do not establish its purpose or electrical levels.

### A18: serial interface, level buttons and PSU links

The front-panel Euro connector has **32 positions in each of two rows
(64 contacts total)**. Preserve the supplied field notation: bare `4` means
provisional top-row `a4`, while `8b` means provisional bottom-row `b8`.
The drawings use rows a/c; the proposed b-to-c correspondence below is supported
by matching signals, but connector orientation remains to be verified.

A18.99, .98, .97 and .96 were listed as power contacts with details omitted;
no voltage or cable destination is assigned here.

| A18 contact (M) | Raw panel contact (M) | Provisional hardware label | 1907 drawing label | Signal / function (D/I) |
| --- | --- | --- | --- | --- |
| 95 | 4 | a4 | a4 | WL20_0: INTERRUPT |
| 93 | 5 | a5 | a5 | WL21_0: PAGING |
| 91 | 8b | b8 | c8 | SOUT_0: Serial data to panel |
| 89 | 9b | b9 | c9 | GND: Serial-line ground |
| 87 | 6b | b6 | c6 | SW_0: Data-switch serial return |
| 85 | 5b | b5 | c5 | GND: Serial-line ground |
| 83 | 6 | a6 | a6 | SREG_0: Register-selector serial return |
| 81 | 3 | a3 | a3 | GND: Explicit ground on 1907; also grounded at 1114 terminal 81 |
| 79 | 7 | a7 | a7 | SLD_0: Parallel-load strobe |
| 77 | 3b | b3 | c3 | GND: Serial-line ground |
| 75 | 7b | b7 | c7 | SCL_1: Serial clock |
| 73 | 4b | b4 | c4 | GND: Serial-line ground |
| 71 | 20 | a20 | a20 | WDOWN_1: Level DOWN contact |
| 69 | 21 | a21 | a21 | WDOWN_0: Level DOWN contact |
| 67 | 22 | a22 | a22 | WUP_1: Level UP contact |
| 65 | 23 | a23 | a23 | WUP_0: Level UP contact |

A18's four additional reported paths go to P1 rather than the Euro connector:

| A18 contact | Direct P1 endpoint (M) | Via confirmed P1 strap | M1 endpoint (M + inferred path) | 1114 drawing function |
| --- | --- | --- | --- | --- |
| 63 | R | R-U | Not supplied; P1 U is not M1.U | PFINT_0; card passes it onward as IPFINT_0 at terminal 21 |
| 61 | T | T-W | M1.X | GND |
| 59 | P | P-V | M1.MM | MINH_0; card passes it onward as IMINH_0 at terminals 20/74 |
| 57 | S | S-X | M1.Y | GND |

These routes identify the A18 functions behind all four P1 straps. Three have
M1 endpoints: P/V → M1.MM, S/X → M1.Y, T/W → M1.X. The R/U pair reaches
A18.63 / PFINT_0, but no onward endpoint beyond P1 U was supplied. **P1 U
is not M1 U**: M1.U instead reaches lowercase P1 v. No connection between
those nets is inferred from the repeated letter. PSU-side voltages/polarities
remain to be established; MINH/PFINT are schematic function names.

The A18.81 → top-row 3 route agrees with the explicit ground at **1907 a3**
on drawing 7B16; terminal 81 is also grounded on 1114.

### A21: eighteen parallel data/address indicator lines

A21.99, .98, .97 and .96 were listed as power contacts with details omitted.
All supplied Euro destinations here are in the provisional top row a. The
entire eighteen-line sequence matches the 1115 drawing, including its
non-sequential panel contact order.

| A21 contact (M) | Raw Euro contact (M) | Provisional hardware / drawing label | 1115 signal (D/I) |
| --- | --- | --- | --- |
| 95 | 8 | a8 | WL0_0 |
| 93 | 10 | a10 | WL1_0 |
| 91 | 9 | a9 | WL2_0 |
| 89 | 11 | a11 | WL3_0 |
| 87 | 12 | a12 | WL4_0 |
| 85 | 13 | a13 | WL5_0 |
| 83 | 30 | a30 | WL6_0 |
| 81 | 28 | a28 | WL7_0 |
| 79 | 29 | a29 | WL8_0 |
| 77 | 27 | a27 | WL9_0 |
| 75 | 26 | a26 | WL10_0 |
| 73 | 25 | a25 | WL11_0 |
| 71 | 19 | a19 | WL12_0 |
| 69 | 17 | a17 | WL13_0 |
| 67 | 18 | a18 | WL14_0 |
| 65 | 16 | a16 | WL15_0 |
| 63 | 15 | a15 | WL16_0 |
| 61 | 14 | a14 | WL17_0 |

### Harness discrepancies and open questions

| Item | Evidence retained | Check required |
| --- | --- | --- |
| **Key / panel lock** | **New M: P1 B → A17.93; D: 1121 PLOCK_0 is terminal 95; Mattis confirms this needs double-checking** | **Outstanding: remeasure 93 vs 95, installed board revision and actual role of the white key wire** |
| **MASTER CLEAR / LOAD lamps** | **Earlier M: j is MASTER CLEAR, k is LOAD; new M: j → A17.59, k → A17.57; D: 59 is LOAD and 57 is MASTER CLEAR; Mattis requests double-check** | **Outstanding: remeasure physical lamps, cable contacts and card revision; neither observation silently replaces the other** |
| **Apparent C-L join** | **Sketch/earlier M: possible permanent C-L join; new M: C → A17.96 and L → A17.81 / SWDEC_0** | **Retrace C-L and DECODE switch/lamp; a permanent join would join those A17 contacts** |
| P1 X / auxiliary memory plug | M: X → M1.Y, raw `M1 plugg 94`; extra memory plug confirmed | Identify exact meaning of 94 and memory-side terminal/function |
| P1 Y / auxiliary memory plug | M: Y → A17.77, raw `M1 plugg 93`; Mattis confirms an extra plug going to the memory system, currently multiport memory | Identify exact meaning of 93 and memory-side terminal/function |
| PFINT onward path | M: A18.63 → P1 R-U; M1.U → P1 v is a separate net | Trace beyond P1 U; no uppercase-P1-U to M1.U connection supplied |
| A17.74 separate plug | New M: goes to a separate plug?; D: IMINH_0 / TW9_0 | Identify plug and onward path; do not assume a measured connection to A18.59 |
| Euro row names / view | Hardware convention provisionally a/b; drawing convention a/c; all supplied signal positions agree under b ↔ c | Confirm row identity and viewing orientation before adapter layout |
| Power rails | M1 colours supplied; A18/A21 contacts 99..96 omitted as power; A17 C reaches 96 | Measure/document voltages and returns; colours alone do not identify rails |
| Replacement key switch | Intended unlocked state described earlier; no new key-position continuity measurements supplied | Verify physical LOCKED/UNLOCKED positions and power-down lockout |

The RTL and FPGA pin allocation are not changed by this cable transcription.
Measured cable endpoints and schematic interpretation remain separate until
these conflicts are resolved.

## Scanned data switches and register selectors

The 18 data switches W0 through W17 are internal to 1907 and are read via SW
and SREG. They are not 18 separate switch-output contacts on the cable. The
data LED inputs WL0 through WL17, by contrast, are separate parallel contacts.
The data switches are drawn in the DOWN position, connected to ground, with
10 kohm pull-ups on the other side.

The register selector buttons share a grounded common and are loaded into the
74L165 chain in **R-code order**, not physical left-to-right order. The R-codes
below use decimal numbering to avoid octal/decimal ambiguity.

| Selector | R-code (decimal) | Serial position after load, first = 1 | Connection | Evidence | Hardware check / notes |
| --- | --- | --- | --- | --- | --- |
| EXM | 15 | 1 | SREG_0 / a6 | D | ? |
| U | 14 | 2 | SREG_0 / a6 | D | ? |
| DATA | 13 | 3 | SREG_0 / a6 | D | ? |
| IR | 12 | 4 | SREG_0 / a6 | D | ? |
| ACTIVE LEVELS | 11 | 5 | SREG_0 / a6 | D | ? |
| DMA ADR | 10 | 6 | SREG_0 / a6 | D | ? |
| ADR | 9 | 7 | SREG_0 / a6 | D | ? |
| P ADR | 8 | 8 | SREG_0 / a6 | D | ? |
| X | 7 | 9 | SREG_0 / a6 | D | ? |
| T | 6 | 10 | SREG_0 / a6 | D | ? |
| A | 5 | 11 | SREG_0 / a6 | D | ? |
| L | 4 | 12 | SREG_0 / a6 | D | ? |
| B | 3 | 13 | SREG_0 / a6 | D | ? |
| P | 2 | 14 | SREG_0 / a6 | D | ? |
| D | 1 | 15 | SREG_0 / a6 | D | ? |
| STS | 0 | 16 | SREG_0 / a6 | D | ? |

After the 16 selector bits, SREG carries **data switch W0**. In the same scan,
SW carries **W17 through W2**, then **W1**. The 1114 drawing shows separate
7474 latches clocked by internal XKL_1 for OPR0 and OPR1, using SREG and SW
respectively. Consequently, neither two-bit tail should be discarded, and a
simple assumption of an independent 18-bit SW frame would be wrong. Confirm
the sampling edges and the stable pre-load/tail intervals before writing HDL.

## Serial output contents and timing

The following order is read from the 1907 timing diagram and 1114's pair of
74165 transmit registers. These are **schematic data names**, not values to
write directly into an FPGA register: SOUT is inverted by G on 1907 before
entering its receiving shift registers.

| Serial position, first = 1 | SOUT content | Display function | Evidence / check |
| --- | --- | --- | --- |
| 1 | RC3 | Register-selection code bit 3 | D |
| 2 | RC2 | Register-selection code bit 2 | D |
| 3 | RC1 | Register-selection code bit 1 | D |
| 4 | RC0 | Register-selection code bit 0 | D |
| 5 | DD3 | Level display units BCD bit 3 | D |
| 6 | DD2 | Level display units BCD bit 2 | D |
| 7 | DD1 | Level display units BCD bit 1 | D |
| 8 | DD0 | Level display units BCD bit 0 | D |
| 9 | DD4 | Level display tens input and serial cascade to S | D: feeds U decoder and S shift register; verify digit encoding before implementation |
| 10 | Unused / crossed out | No assigned display bit | D: timing diagram; do not assign a function |
| 11 | RING0 | Protect ring 0 indicator | D |
| 12 | RING1 | Protect ring 1 indicator | D |
| 13 | RING2 | Protect ring 2 indicator | D |
| 14 | RING3 | Protect ring 3 indicator | D |
| 15 | MINUS | Level-down indicator | D |
| 16 | PLUSS | Level-up indicator | D: original spelling PLUSS |

| Timing item | Value shown on 1907 | Outstanding check |
| --- | --- | --- |
| SLD_0 load pulse | 200-300 ns, low pulse | Verify on actual panel/interface |
| Scan repetition interval | 2.5-3.5 ms | Compare with intended FPGA scan rate |
| SCL_1 burst | 16 pulses per scan | Determine exact input/output sampling edges |
| SCL period in burst | 600-800 ns | Include buffer and cable delays in implementation |
| XKL_1 waveform | 9-13 us marked on square-wave span | Internal 1114 signal; not a contact identified on 1907 |

## Cabling investigation checklist

| Item to establish | Result |
| --- | --- |
| 1907 actual PCB revision and fitted ECO changes | ? |
| Separate button/key connector identity and count | M: rectangular P1, 56 poles; full label sequence recorded above |
| P1 connector mating/wiring view and wire colours | M/D sketch: B white, C black, s grey/blue, t white/blue, v red/brown, A green at START lamp, apparent L pink/brown; connector view ? |
| P1 connector links | **M: A-E, C-H, P-V, R-U, S-X and T-W confirmed inside connector; apparent C-L harness join provisional** |
| 1907 connector type, contact count, and numbering view | M: 32 positions × 2 rows = 64 contacts; top a / bottom b provisional; drawing uses a/c; mating view ? |
| +5 V feed contact(s), ground returns, and any separate power leads | ? |
| Actual 1114/1115/1121 revisions, if using them for comparison | ? |
| Continuity of each a/c contact to the named interface-card terminal | M: A18/A21 tables now record 16 Euro signal/ground routes and 18 lamp routes; a/b-to-a/c row identity remains provisional |
| Continuity of PB-labeled signals to actual button-connector contacts | **M: A17 table now resolves most routes and complementary phases; j/k lamps and B/93 vs PLOCK/95 remain discrepant** |
| Make/break contacts for the white buttons | **M: recorded above; MASTER CLEAR break and all DECODE ADDRESS assignments to recheck** |
| DECODE ADDRESS switch and lamp | **Recheck common, make, break and lamp leads; previous L/shared-terminal assignment questioned by apparent C-L join** |
| **Apparent P1 C-L connection** | **D sketch / M provisional: black C joins pink/brown L; verify continuity and location** |
| START make 1 and lamp | D sketch: C through START make 1 to black lamp terminal; green lamp return to A; external C drive and lamp rating ? |
| START make 2 | D sketch: v-t make; M: v → M1.U, t → M1.NN; external PSU functions not established |
| START break | D sketch: s to brown key pair 2 break, closed with START released; M: s → M1.j |
| Key-switch pair 1 | M/D sketch: common C/H, make B, break other buttons' common; verify actual key-position labels and bus scope |
| Key-switch pair 2 | D sketch: common v via red, make grey/t, break brown/s through START break; verify actual key-position labels |
| Button-contact common vs ground/lamp common | Other buttons' common through key pair 1 break to C; no permanent A/E connection established |
| Replacement key switch | Original missing, replacement fitted; drawn position intended UNLOCKED but physical labels/polarity unverified; planned check noted on 2026-10-23, result not yet reported |
| Intended key-switch lockout | LOCKED: inhibit panel buttons and power-down of running computer; UNLOCKED: permit functions. Verify actual external circuit behavior |
| Button lamp ratings and drive paths | **START green return now A; DECODE lamp under review; all lamp ratings and card-side drive paths remain open** |
| Red button name | Confirmed START; same unlabelled red button in POWER section, called POWER on hand sketch |
| P1 unconnected positions | M: l, m, n, p, r, u; all positions w through NN; uppercase L is distinct from lowercase l |
| Remaining unidentified P1 signal functions | **Three A18-to-M1 strap paths traced; PFINT onward beyond P1 U unknown. s/t/v semantics, C/B voltages/functions, C-L, lamp swap, 93/95 and auxiliary memory-plug numbering remain open** |
| Auxiliary memory-system plug | M: extra plug currently goes to multiport memory; P1 X/annotation 94 and P1 Y/annotation 93 branches; actual designation, numbering and purpose to establish |
| Any unlisted populated contacts, straps, cable joins, or modifications | ? |

This worksheet specifies no FPGA package pins or adapter component values.
Those can be assigned once the connector/power mapping and actual hardware
revisions have been checked.
