# Rebuild request: 16-qubit ZCU216 bitstream with a 32-deep timed queue

This asks for one new bitstream of the 16-qubit 430 MHz build with `queue_depth` raised from 4
to 32, and explains why. Everything else about the build stays as in
[`zcu216-16q.md`](zcu216-16q.md), which describes the design and the build flow.

| | |
|---|---|
| What to build | [`software/configs/zcu216-16q-430-q32.json`](software/configs/zcu216-16q-430-q32.json) |
| Difference from the build on the board | `queue_depth` 4 → 32, and the name; nothing else |
| Expected effort | one build, about 3 hours on the Vivado workstation |
| Main risk | timing: the current build met 430 MHz with only +0.016 ns of slack |
| What to send back | `PulseTableSoc.xsa`, the config, and three reports (see [Deliverables](#deliverables)) |

---

## The problem

The 16-qubit build on the board cannot play short gates back to back. With gates at IBM Heron
lengths (sx / x 24 ns, about 10 `dspClk` cycles at 430 MHz), a run of more than four gates on
one qubit needs idle time inserted after every gate, about 70 ns each.

Two properties of the build combine to cause this:

1. **Each pulse parameter sits behind a 4-entry [`TimedQueue`](docs/dsp/TimedQueue.md).** The
   link from the core is posted, so a push into a full queue is dropped without telling the
   core. Software must therefore never have more than four plays pushed ahead of the one
   playing: it may push play *k* only once play *k − 4* has started.
2. **A push must land `LEAD` = 96 cycles before its play** (`software/riscq/map.py`).

So play *k* starts four gate lengths after the moment it may be pushed, and that span has to
cover 96 cycles plus the time the core needs for the push (about 37 cycles: a wait and three
stores at 6 cycles each). Four 10-cycle gates give 40 cycles where about 133 are needed.
Gates of 34 cycles or more are unaffected, which is why the calibration code's
`TRAIN_STEP = 36` works.

The queue depth is a parameter of the build, not of the architecture. The 8-qubit `x6y3`
config already uses `queue_depth: 32`. The 16-qubit configs kept the default of 4.

## Evidence that depth 32 fixes it

Measured in the Verilator co-simulation of a 2-core build at 430 MHz, identical except for
`queue_depth`. Each program is straight-line code per qubit (`set_phase_offset` + `fire` or
`play` per gate, a `wait_until` before a push when the queue would otherwise overfill), with
gates at Heron lengths. In every case the gate DAC was busy on exactly the scheduled cycles.

| Circuit | Idle time inserted, depth 4 | Idle time inserted, depth 32 |
|---|---|---|
| `grover_n2` (8 gates) | 45 cycles (6 % of the shot) | none |
| `dnn_n2` (141 gates) | 1,279 cycles (47 %) | 92 cycles (3 %) |
| 200 back-to-back gates, a new phase each | 6,084 cycles | 5,479 cycles |

The last row is an artificial worst case and is limited by the core's store rate, not by the
queue; it is not expected to improve further.

The same check has not been run with 16 cores, and nothing has been run on hardware at
depth 32 with this design.

## What to build

The config is already in the repo. It is `zcu216-16q-430.json` with two lines changed:

```diff
-    "name": "zcu216-16q-430",
+    "name": "zcu216-16q-430-q32",
-    "queue_depth": 4,
+    "queue_depth": 32,
```

Build it exactly as the 430 MHz build was built (see
[Building the bitstream](zcu216-16q.md#building-the-bitstream) for prerequisites and what the
script does):

```bash
mkdir -p build/zcu216-16q-430-q32
vivado-scripts/riscvsoc-bd/build-riscvsoc-bd.sh \
    RISCQ_CONFIG=software/configs/zcu216-16q-430-q32.json \
    RISCQ_PROJ_NAME=zcu216-16q-430-q32 \
    RISCQ_SPAN=5 \
    2>&1 | tee build/zcu216-16q-430-q32/build.out
```

- `RISCQ_SPAN=5` is required, as for every 16-core build.
- The RTL must be regenerated: `queue_depth` changes the generated design, so do not reuse
  another build's folder with `RISCQ_SKIP_GEN=1`.
- `queue_depth` applies to every channel of every core: the gate drive, the readout drive and
  the demodulator.

## What to expect

**Area.** The default queue implementation (`RegHead`) stores its entries in distributed RAM.
[`TimedQueue.md`](docs/dsp/TimedQueue.md) notes that at depth 32 this storage is "depth-free"
(RAM32 primitives), so the growth should be modest. The 430 MHz build stands at LUT 52 %,
FF 53 %; please report the new figures.

**Timing.** This is the uncertain part. The current build closed at WNS +0.016 ns, and the
queues sit in the datapath region next to the pulse generators. A small miss is plausible.

If timing misses, in this order:

1. Run the incremental pass (it gained 23 ps at 475 MHz):
   ```bash
   vivado-scripts/riscvsoc-bd/close-incremental.sh RISCQ_PROJ_NAME=zcu216-16q-430-q32 RISCQ_SPAN=5
   ```
   If it closes, write the bitstream and XSA from `routed_incr.dcp`.
2. Try `queue_depth: 16` (copy the config, change the value and the name). Sixteen entries
   already cover most of the benefit: the gain comes from being able to push more than
   `LEAD` / gate length ≈ 10 plays ahead.
3. Report the miss (WNS, failing endpoints, the worst paths' modules) rather than lowering
   `dsp_freq_hz`. The board can only be clocked at 430 MHz or 500 MHz with this clock tree
   ([Why 430 MHz](zcu216-16q.md#why-430-mhz)), so a frequency in between is not usable.

Changing the queue implementation (`Srl`, `SrlShadow`) is possible but changes the drain rate
and is not exposed in the config; leave it unless the options above fail, and say so if you
try it.

## Acceptance

The build is good when all of these hold, as for the 430 MHz build:

- `[rfdc-config] dspClk 430.0 MHz → DAC 6.880 GS/s (tile-2 PLL), ADC 1.720 GS/s` appears early
  in the log;
- `timing_impl.rpt` (or `timing_incr.rpt`) says "All user specified timing constraints are
  met", and `cones_impl.rpt` ends with `TOTAL 0`;
- `PulseTableSoc.bit` and `PulseTableSoc.xsa` are in `build/zcu216-16q-430-q32/`.

The critical warnings listed under
[Check the result](zcu216-16q.md#check-the-result) are expected.

## Deliverables

From `build/zcu216-16q-430-q32/`:

- `PulseTableSoc.xsa`
- `software/configs/zcu216-16q-430-q32.json`, unchanged (the board checks that programs were
  compiled for exactly this file)
- `timing_impl.rpt` (and `timing_incr.rpt` if the incremental pass was used), `util_impl.rpt`,
  `build.out`

Please also state: post-route WNS and WHS, failing endpoints, LUT / FF utilisation, build time,
and which of the fallback steps were needed, if any.

## Optional second build: more core memory

Only if the workstation has room for a second build alongside, and after the first is
running: [`software/configs/zcu216-16q-430-q32-m8k.json`](software/configs/zcu216-16q-430-q32-m8k.json)
is the same config with `mem_depth` 4096 → 8192 words (16 KB → 32 KB per core, as in `x6y3`).

Reason: with gates compiled into the program, one benchmark circuit (`basis_trotter_n4`, 796
gates on one qubit, about 22 KB of code) does not fit 16 KB. BRAM use is at 9 %, so capacity
is not the concern; timing is. Use `RISCQ_PROJ_NAME=zcu216-16q-430-q32-m8k` so the two builds
do not share a folder. This build is lower priority and should not delay the first.

## After the build (not part of this request)

For whoever brings the bitstream up on the board:

- Software reads the queue depth from the bundle's config, so the quOS backend's pacing adapts
  without a code change. `riscq.cal.base.TRAIN_AHEAD` is a fixed 4 and does not; it stays
  correct, only conservative.
- Programs must be recompiled against the new config: the board refuses job files built for
  another config, and the name differs.
- The current bitstream fails multi-tile sync because the RF Data Converter IP has MTS
  disabled on DAC tiles 1–3; the board is run with MTS skipped. This rebuild does not need to
  change that, but if it is fixed in the same build, say so.
