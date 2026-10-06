# Human Responses to Visually Evoked Threat — intracranial EEG (3 patients)

Intracranial EEG of **3 patients** with treatment-resistant epilepsy (UCSF, under the care of Dr. Edward Chang) who
experienced immersive virtual-reality (VR) stimuli: a modified virtual-heights stimulus, a matched "no heights" control
and (two patients) a 360° shark movie, with simultaneous skin conductance and eye/visual-scanning measures.
This is the iEEG part of the release "Human Responses to Visually Evoked Threat" (Dryad doi:10.5061/dryad.wdbrv15mq,
mirrored on Zenodo as record [4283021](https://zenodo.org/records/4283021); licence **CC0 1.0**).

Reference article: Yilmaz Balban M, Cafaro E, Saue-Fletcher L, Washington MJ, Bijanzadeh M, Lee AM, Chang EF, Huberman AD
(2021). *Human Responses to Visually Evoked Threat.* Current Biology 31(3):601–612.e3. https://doi.org/10.1016/j.cub.2020.11.035

## Participants
`participants.tsv` gives, per patient, age, gender, STAI state/trait and GAD-7 from Table S1 of the paper
(EC192: M, 33 y; EC200: M, 23 y; EC205: F, 44 y). Electrodes: EC192 and EC205 depth electrodes; EC200 a 64-contact grid
and strips. Electrodes in insula (EC192, EC205) and orbitofrontal cortex (EC200, EC205) were the focus of the paper.

## Tasks
- `task-heights`: modified heights stimulus (sudden appearance of a narrow plank ~150 ft above ground); iEEG covers
  5 min before the stimulus ("No Visual Stim") and the stimulus.
- `task-noheights`: no-heights control (identical VR environment, walls/ceiling removed, no heights); release file
  `TDTData_B*_baseline` (EC205: `baselineinVR`).
- `task-sharks`: 360° shark movie (EC192, EC205).

## Recording
Tucker-Davis Technologies PZ2 (256-ch) or PZ5 (512-ch) amplifier with an RZ2 acquisition system, 3051.7578 Hz. The VR
headset was secured with a custom Velcro cap. Reference not documented in the release.

## What was converted, and how
- Each `TDTData_B<block>_<condition>.mat` (MATLAB 7.3) holds the iEEG array (`rawData` or `Data`; where both exist they
  were verified identical), its sampling rate, and `ANIN` (4 analog inputs at 24414.0625 Hz). The iEEG array (channels ×
  samples, float64, **volts**) was written as BrainVision IEEE float32 in V (file value = stored value rounded to
  float32). No filtering, resampling, re-referencing or channel removal; all 128 (EC192, EC200) / 64 (EC205) inputs kept.
- **Channel names**: the release gives no channel labels; channels are `ch001…` in array order. The electrode tables of
  the release (`<EC n>_TDT_elecs_all_warped.mat`: 94 / 100 / 52 rows, name, long name, type, anatomical label, xyz) are
  provided as `electrodes.tsv` (`space-Other`) with the row number, but **the mapping of TDT inputs to electrode rows is
  not documented**, so no link between channels and electrodes is asserted. Channel `type` is the patient's implant type.
  Rows whose name and type are `NaN` in the release (EC192 rows 31, 32, 63, 64; EC205 rows 31, 32; all with the same dummy
  position) are listed as `unlabeled_row<k>` with n/a coordinates. (Observation only: such placeholders at positions
  31–32 and 63–64 are consistent with rows following amplifier-input order, but the release does not state it.)
- **Events**: the release holds per-condition `syncOnTime` and `gsrshift`/`GSRsynctime` values used by the authors'
  `AACorrGSR_stanford.m` to time-lock iEEG and skin conductance, and visual-scanning vectors (`VS_heights`, 1 value per
  second). Their time origin is not documented precisely enough to place them on the iEEG time axis, so no `events.tsv`
  is generated; the files are in `sourcedata/`.
- `sourcedata/zenodo-4283021/`: the iEEG folder (TDT files incl. ANIN, skin-conductance arrays, sync times, visual scans,
  analysis code), the electrode-location folder and the release read-me, extracted from the zips (macOS `__MACOSX`
  and `.DS_Store` entries dropped). In every `.mat`, only the day in the MAT-file header text "Created on: …" was masked
  to `01` (weekday `---`); SHA-256 of original and public bytes are in `sourcedata/b2zen_provenance_IEEG044.json`.
- **Not included**: the healthy/anxious VR participants' data (gaze, game, physiology, survey; no iEEG) — their session
  logs contain real session date-times. They are available from the CC0 source record.

## Licence
CC0 1.0 (Zenodo metadata license id `cc-zero`; Dryad publishes all data under CC0).
