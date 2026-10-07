# Human Responses to Visually Evoked Threat — intracranial EEG (3 patients)

## Overview
Intracranial EEG of **3 patients** with treatment-resistant epilepsy (UCSF, under the care of Dr. Edward Chang) who
experienced immersive virtual-reality (VR) stimuli: a modified virtual-heights stimulus, a "no heights" baseline in VR
and (two patients) a 360° shark movie, with simultaneous skin conductance and eye/visual-scanning measures.
This is the iEEG part of the release "Human Responses to Visually Evoked Threat" (Dryad doi:10.5061/dryad.wdbrv15mq,
mirrored on Zenodo as record [4283021](https://zenodo.org/records/4283021); licence **CC0 1.0**).

Reference article: Yilmaz Balban M, Cafaro E, Saue-Fletcher L, Washington MJ, Bijanzadeh M, Lee AM, Chang EF, Huberman AD
(2021). *Human Responses to Visually Evoked Threat.* Current Biology 31(3):601–612.e3. https://doi.org/10.1016/j.cub.2020.11.035 (author manuscript: PMC8407368). Data and analysis code: Dryad
doi:10.5061/dryad.wdbrv15mq.

## Participants / cohort
Three patients with treatment-resistant epilepsy implanted with intracranial electrodes for localisation of seizure foci,
recorded at the UCSF Hospital (under the care of Dr. Edward Chang); they were included if they had electrodes in the regions
of interest (insula, orbitofrontal cortex) and were willing to do the VR task; implantation was guided solely by clinical
decision (paper, STAR Methods). `participants.tsv` gives, per patient, age, gender, STAI state/trait and GAD-7 from Table S1
of the paper (EC192: M, 33 y; EC200: M, 23 y; EC205: F, 44 y); the patient labels (EC 192, EC 200, EC 205) are identical in
the release folders and in the paper. Electrodes: EC192 and EC205 depth electrodes; EC200 a 64-contact grid and strips.
Electrodes in insula (EC192, EC205) and orbitofrontal cortex (EC200, EC205) were the focus of the paper. Further columns:
implant type, number of electrode leads and implanted hemisphere (right for all three; derived from the release electrode
tables), the paper's regions of interest, the number of visual scanning episodes during heights reported in the paper
(EC192: 3, EC200: 0, EC205: 2), and the year-month of the TDT iEEG exports (MAT-file headers: 2019-02, 2019-05, 2019-08;
the recordings took place on or before these months, exact dates are not documented).
The healthy and anxious VR participants of the paper (no iEEG) are not part of this dataset.

## Tasks
- `task-heights`: modified heights stimulus, adapted to the patients' mobility constraints: seated in a chair in a virtual
  copy of their hospital room, playing the 'lights-out' task (4 × 4 light grid; clicking a light toggles it and its
  neighbours, goal: all lights off) in front of them; 1 min into the task the walls and the floor of the virtual room fall
  away, leaving the subject seated on a platform of a building 50 stories high. iEEG covers 5 min before the stimulus
  ("No Visual Stim") and the stimulus. (The healthy-participant version with a narrow plank ~150 ft above ground that had
  to be crossed is described in the paper but is not the patients' version.)
- `task-noheights`: "No Heights" baseline: 5 min in the virtual hospital room without the heights stimulus, measured before
  the heights stimulus (paper, Modified Heights Stimulus); release file `TDTData_B*_baseline` (EC205: `baselineinVR`).
- `task-sharks`: 360° movie of swimming with great white sharks (filmed at the Guadalupe Island field station), presented
  on the inner surface of a virtual sphere (EC192, EC205; Figure S5).
VR: Unity-programmed stimuli shown in an HTC Vive headset (secured with a custom Velcro cap); skin conductance was recorded
simultaneously with the iEEG (paper).

## Acquisition
Tucker-Davis Technologies PZ2 (256-ch) or PZ5 (512-ch) amplifier with an RZ2 acquisition system, 3051.7578 Hz. The VR
headset was secured with a custom Velcro cap. Reference and ground not documented in the release. Electrode localisation in
the paper: pre-operative 3T T1 MRI co-registered with post-operative CT (SPM12), confirmed by a neurologist; pial surfaces
reconstructed with FreeSurfer.

## Preprocessing already applied by the source
None: the release holds the raw TDT exports. The paper's analysis steps (downsampling to 400 Hz, notch at 60/120/180 Hz,
common average reference per lead, exclusion of noisy channels/epochs) were NOT applied to these data.

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

## Known caveats (summary)
- Channel-to-electrode mapping is not documented (see above); channel names are `ch001…`.
- No `events.tsv` (time origin of the sync values not documented).
- Units: volts as stored in the TDT export.
- In `electrodes.tsv` of EC205 the `group` value `OFC` covers three 10-contact leads (OFC11–OFC110, OFC21–OFC210,
  OFC31–OFC310); `iEEGElectrodeGroups` and `n_electrode_leads` count them separately.
- The paper's Results text refers to EC 200 as "her", while Table S1 lists EC 200 as M; `participants.tsv` keeps Table S1.
- Earlier versions of the `*_ieeg.json` TaskDescription described the heights task with the healthy-participant plank and
  the no-heights run as the healthy-participant control; both were corrected on 2026-10-07 per the paper's "Modified
  Heights Stimulus" section.

## How to load
```python
from mne_bids import BIDSPath, read_raw_bids
bp = BIDSPath(root=".", subject="EC192", task="heights", datatype="ieeg")
raw = read_raw_bids(bp)   # 128 channels ch001..ch128, volts, 3051.7578 Hz
```

## Citation
Yilmaz Balban M, et al. (2021) Human Responses to Visually Evoked Threat. Curr Biol 31(3):601–612.e3.
doi:10.1016/j.cub.2020.11.035; data: doi:10.5061/dryad.wdbrv15mq.

## Provenance / sources
Dryad doi:10.5061/dryad.wdbrv15mq / Zenodo record 4283021 (record JSON, "Read me for STARS.docx", electrode tables, MAT
headers); Yilmaz Balban et al. 2021 (author manuscript PMC8407368: STAR Methods, Results, Acknowledgments) and its
Supplemental Information (Table S1, Figures S3–S5). Metadata enrichment 2026-10-07 (see CHANGES).

## Licence
CC0 1.0 (Zenodo metadata license id `cc-zero`; Dryad publishes all data under CC0).
