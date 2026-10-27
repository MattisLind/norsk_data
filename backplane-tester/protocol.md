# Proposed firmware and laptop control

This is an interface specification, not implemented firmware. Both cards run
the same image. The host assigns transmitting/receiving roles and slot labels;
neither role is permanently wired into a board.

## Firmware essentials

- USB full-speed CDC device; derive a stable USB serial string from the MCU's
  unique ID. A laptop records both serial numbers and assigned slot names.
- HSE-based 48 MHz system/USB clock; ADC1 input 0 at a proposed 12 MHz ADC clock.
- GPIO mode table and address mapping in [hardware.md](hardware.md).
- `MUX_DISABLE=1` and all stimulus pins analogue/high impedance at startup,
  reset, USB suspend, USB loss, explicit SAFE or host lease expiry.
- Reject invalid commands, addresses outside 0–99, unsupported modes and
  commands that would select an invalid mux bank. Return to SAFE on a command
  error rather than leaving an unknown stimulus active.
- Hardware watchdog; bounded line lengths; one operation at a time. Configure
  unused MCU GPIOs as analogue inputs, preserving SWD and boot-pin requirements.
- No test stimulus until both cards are powered and the laptop has identified
  them. USB commands and ready acknowledgements coordinate the cards; their
  only direct connection is the ground wire.
- USART1 on J5 is for application debug logging and the factory serial
  bootloader. It is not an inter-board or tester-control interface. Proposed
  application logs use 115200 8N1; factory programming uses AN3155 / 8E1.
  The hardware BOOT0 jumper and reset button allow recovery with blank or
  nonworking application firmware; see [hardware.md](hardware.md#firmware-download-through-the-built-in-bootloader).

Use a host lease, initially 5 seconds. Successful commands and `KEEPALIVE`
renew it. A long SCAN must check the lease/abort flag between measurements;
the host sends keepalives if needed. These timing values are prototype defaults.

## Selection and sampling

For any address or mode change:

1. Assert MUX_DISABLE.
2. Release upper stimulus GPIOs, then lower GPIOs to analogue-input mode.
3. Write all seven address bits; set the required lower GPIO low before
   enabling any high-producing upper GPIO.
4. Wait a conservative initial 2 µs for digital control to settle.
5. Deassert MUX_DISABLE, wait the configured analogue settling interval.
6. Discard one ADC conversion, then average the requested number of samples.
   Retain min/max to reveal unstable readings. No digital threshold is required.

The default settling interval is 1000 µs and averaging count is 8. ADC_SENSE
stays in analogue mode throughout. Values are proposed starting settings,
not measured backplane requirements.

SCAN performs this sequence locally for each requested contact and leaves
the board SAFE when complete. HOLD leaves a selected stimulus active only
while the lease is valid. The receiver should not rely on a floating sense-only
reading to distinguish an open: always apply BIAS_HIGH or BIAS_LOW.

## USB command sketch

Use newline-delimited JSON objects over CDC. Each request has a host sequence
number `id`; responses echo it. Example requests and responses:

```json
{"id":1,"cmd":"INFO"}
{"id":1,"ok":true,"protocol":1,"serial":"<MCU-unique-id>","contacts":100,"adc_bits":12,"state":"SAFE"}

{"id":2,"cmd":"HOLD","contact":37,"mode":"DRIVE_LOW"}
{"id":2,"ok":true,"state":"HOLD","contact":37,"mode":"DRIVE_LOW","source_adc_mean":42}

{"id":3,"cmd":"SCAN","first":0,"count":100,"mode":"BIAS_HIGH","settle_us":1000,"samples":8}
{"id":3,"contact":0,"adc_mean":2450,"adc_min":2448,"adc_max":2453}
{"id":3,"contact":1,"adc_mean":520,"adc_min":518,"adc_max":522}
{"id":3,"done":true,"count":100,"state":"SAFE"}

{"id":4,"cmd":"KEEPALIVE"}
{"id":4,"ok":true}

{"id":5,"cmd":"SAFE"}
{"id":5,"ok":true,"state":"SAFE"}
```

ADC numbers above are illustrative, not acceptance values. A real 100-contact
SCAN emits 100 measurement records before its completion record.

| Command | Meaning |
| --- | --- |
| INFO | Identity, protocol revision, capabilities and state |
| HOLD | Select contact and mode, await settling, sample source ADC, acknowledge |
| SAMPLE | Sample the current selection; requires an active HOLD |
| SCAN | Scan a bounded range in BIAS_HIGH or BIAS_LOW mode; finish SAFE |
| BASELINE | Disable muxes; measure the local BIAS_HIGH and BIAS_LOW levels; finish SAFE |
| KEEPALIVE | Renew the host lease without changing selection |
| SAFE | Abort operation, disconnect all muxes and release stimulus GPIOs |

BASELINE returns mean/min/max for both bias modes. For early firmware,
SCAN may finish collecting a row into RAM before transmitting it (100 records
of compact ADC statistics fit easily); SAFE and the lease still need service
during acquisition. Avoid blocking ADC loops that prevent abort handling.

## Host scan sequence

1. Enumerate cards by USB serial; assign physical slot labels. Verify that
   the ground cable is connected and both cards are powered.
2. Send SAFE to both and obtain each board's BASELINE readings.
3. For each transmitter contact `a` from 0 through 99:
   - HOLD `a` / DRIVE_LOW on A; wait for its ready acknowledgement.
   - SCAN all 100 contacts / BIAS_HIGH on B. Store the low-test row.
   - HOLD the same `a` / DRIVE_HIGH on A; wait for acknowledgement.
   - SCAN all 100 contacts / BIAS_LOW on B. Store the high-test row.
   - SAFE A. Keep A's lease alive during each receiver scan.
4. SAFE both. Optionally reverse A/B for a consistency check or repeat
   uncertain readings with longer settling.
5. Persist raw data before computing connected components or reports.
6. Obtain SAFE acknowledgements from both boards before moving either card.

At 1 ms settling, a one-polarity 10,000-pair matrix has a 10-second settling
floor; both polarities have a 20-second floor. ADC averaging, control changes,
USB transport and row acknowledgements add time. Report measured scan time
rather than promising those floors as end-to-end performance.

## Classification and records

Always retain raw ADC results. Let `Lref` and `Href` be the receiver's local
BASELINE low/high values. Normalize a reading as:

```text
x = (ADC - Lref) / (Href - Lref)
```

Initial **experimental** bands:

- Connected candidate: low-test `x < 0.35` and high-test `x > 0.65`.
- Open candidate: low-test `x > 0.80` and high-test `x < 0.20`.
- Otherwise: uncertain; repeat with longer settling and inspect the path.

These are provisional heuristic bands, not continuity-resistance limits.
The high-test drive is generated on the other board and may differ slightly
from the receiver's baseline. Source ADC readings, calibration fixtures and
reversed scans help characterize that difference. Detect failed or compressed
baseline spans before applying any classification.

Store board serials, slot names, firmware/protocol revision, mapping revision,
timestamp, polarity, source contact, receiver contact, ADC mean/min/max,
source ADC reading, baseline values, settling time and averaging count.
Do not discard open results: they distinguish a checked pair from an untested
pair. Missing or contradictory results stay uncertain rather than becoming
implicit opens or automatic net merges.

Use logical endpoint identities `(slot, BPxxx)` initially. Add verified printed
terminal labels later. Across placements, union confirmed joins into nets and
flag contradictory observations for review. To verify against drawings, compare
expected endpoint membership with measured membership; the first scan alone
cannot tell an intended join from a short.

No single fixed slot covers local nets absent from that slot. With no prior
wiring knowledge, every unordered pair of distinct slots is the conservative
full-discovery schedule. Nets confined to one slot can be detected via another
slot only if they reach it; a second independently selectable measurement path
on the same slot would be needed to characterize strictly slot-local joins.
