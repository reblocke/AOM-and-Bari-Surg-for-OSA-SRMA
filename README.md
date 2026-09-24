# Anti-obesity medications and bariatric surgery for obstructive sleep apnea: SRMA code and extracted data

This repository contains the Stata analysis script and study-level extraction material associated with “The association of weight loss from anti-obesity medications or bariatric surgery and apnea–hypopnea index in obstructive sleep apnea” (*Obesity Reviews*, 2024; 25(4):e13697). It supports inspection and attempted reproduction of the scripted meta-analyses and meta-regressions. The current source has a graph-export path defect, and this README does not certify a successful end-to-end run or agreement with the published exhibits.

- [Article DOI](https://doi.org/10.1111/obr.13697) · [PubMed](https://pubmed.ncbi.nlm.nih.gov/38342767/) · [open-access article](https://pmc.ncbi.nlm.nih.gov/articles/PMC11311115/) · [PROSPERO registration](https://www.crd.york.ac.uk/PROSPERO/view/CRD42022378853)
- [Stata source](./OSA%20Wt%20Loss%20SRMA.do) · [citation metadata](./CITATION.cff) · [contribution guidance](./CONTRIBUTING.md)

## Run the existing script

The do-file declares **Stata 18**. It uses Stata's `meta` commands and calls `adjust`; its graphs select `cleanplots`, `white_tableau`, and `white_w3d` schemes. The repository does not install or pin those schemes or any additional command packages. Their availability, the licensed Stata environment, and platform compatibility have not been tested for this README change.

Start Stata with this repository as the working directory. The script copies `OSA Wt Loss SRMA.do` by its bare filename, and its derived-data output is relative to the working directory even when the workbook directory is supplied separately.

```stata
cd "/path/to/AOM-and-Bari-Surg-for-OSA-SRMA"
do "OSA Wt Loss SRMA.do"
```

The optional arguments are, in order, `workbook_dir` and `output_root`. They default to `.` and `Results and Figures`. To use a different workbook directory and a new result root whose parent already exists:

```stata
do "OSA Wt Loss SRMA.do" "/path/to/workbooks" "my-results"
```

`workbook_dir` must contain `Data Extraction Table.xlsx`. The script checks for that file, imports its `Sheet1` with the first row as headers, and does **not** import the RoB workbook or the `AGL check` sheet. The example is source-inspected, not an executed reproduction command; see the [current blocker](#output-and-verification-boundary) before running it in a disposable checkout.

## Inputs and data meaning

| Tracked file | Role in this repository | Used by the do-file? |
|---|---|---|
| [`Data Extraction Table.xlsx`](./Data%20Extraction%20Table.xlsx), `Sheet1` | Extracted intervention/control comparisons with author, year, DOI, group sizes, weight and AHI measures, follow-up, and a `RoB` field. | **Yes**; the script retains rows with nonmissing `stauthor`. |
| Same workbook, `AGL check` | Separate extraction-review sheet. | No. |
| [`ROB2_OSA SRMA.xlsx`](./ROB2_OSA%20SRMA.xlsx), `Sheet 1` | Supporting study-level RoB2 domain and overall judgments. | No; the analysis uses the `RoB` field already in `Sheet1`. |

An imported row is an extracted comparison, not necessarily a unique trial; the script does not enforce a DOI or study-key uniqueness rule. It constructs a display label from author, year, and intervention type. The workbook headers specify AHI, weight, ESS, and follow-up fields; follow-up is labeled in months, percentage weight change is labeled as such, and weight-unit columns are present. The script's AHI plots label absolute change in events/hour. Check the workbook and article before interpreting a field whose unit or derivation is not explicit.

The do-file converts selected workbook columns to numeric values with `destring`, calculates `int_wt_loss_effect = controlmeanweightchange - intmeanweightchange`, derives weight-loss categories including a 10% threshold, converts the `RoB` field, and prefixes intervention labels. It has no documented rule equating a blank or failed conversion with a negative result. Keep the source workbook headers stable when comparing the documented workflow to the script. These are compiled **study-level** tables; the repository does not contain patient-level records or PHI.

## Output and verification boundary

| Source step | Intended or defined location | What is established |
|---|---|---|
| Setup and log | `<output_root>/<Stata $S_DATE>/Logs/osa_wt_loss_srma.log`, plus a time-stamped copy of the do-file in `Logs/` | The script creates these directories, then opens the text log and copies its source. A repeated run may replace the log. |
| Cleaned/derived data | `outputs/stata/osa_antiobesity_srma.dta` relative to the repository working directory | The script saves and later reuses this Stata dataset. It is **not** routed under `output_root`. |
| Graphs | PNG names under the dated result directory, as declared in the script | `graph export` statements already exist, but their `results_dir` macro uses a backtick where Stata requires a closing apostrophe (first occurrence at line 97, repeated through the final export). Successful paths or files have not been verified. |
| Tables/statistics | Stata results and the opened log | `meta summarize`, `meta regress`, and related commands are present; the script has no CSV, Excel, or `putexcel` table-export call. |

The malformed graph paths are a **separate code issue**: inspect and correct those macro delimiters in an authorized do-file change, then run the script with a new output namespace and check the log and files. This documentation PR does not edit the do-file. A Stata run, graph creation, table reproduction, and comparison with the paper were **not performed** for this README update. An opened log or derived `.dta` alone would not establish completion of the full script.

## Source-to-exhibit guide

The mapping below reports source labels and intended outputs, not verified agreement with the publication. The named PNG exports are subject to the path defect above.

| Source section | Named product in the do-file | Qualification |
|---|---|---|
| Absolute AHI-change forest plots | `Figure 2 AHI Diff by 10 Perc Wt Loss.png`; `Figure 3- AHI Diff by Type and Intervention.png` | The Figure 3 comment says its labels require manual editing. |
| Main meta-regression and bubble plots | `Figure 4- Wt Loss v AHI Diff Meta Regress.png`; `Figure S5- Wt Loss v AHI Diff Meta Regress by type.png` | Lines contain export calls; publication match is unverified. |
| Relative AHI, sleepiness, and exclusion/RoB sensitivity sections | Figure S6 variants and `Supplement ... .png` names in the script | The comments and filenames are the available crosswalk; completeness and final publication numbering are unverified. |
| Numerical tables | No dedicated table files named by the script | Review Stata output/log against the paper; do not infer a table export from a figure comment. |

## Citation, rights, and support

Preferred article citation:

> Locke BW, Gomez-Lumbreras A, Tan CJ, Nonthasawadsri T, Veettil SK, Patikorn C, Chaiyakunapruk N. The association of weight loss from anti-obesity medications or bariatric surgery and apnea–hypopnea index in obstructive sleep apnea. *Obesity Reviews*. 2024;25(4):e13697. doi:10.1111/obr.13697.

The [MIT license](./LICENSE) covers repository software. The extraction and RoB workbooks are supplied to support review of the article; cite the article when using them, and describe changes if redistributing modified versions. Check data/third-party reuse rights separately from the code license. Cite or acknowledge this repository when adapting its code; see [CITATION.cff](./CITATION.cff) for software metadata. Funding included NIH Ruth L. Kirschstein NRSA **5T32HL105321** and the American Thoracic Society ASPIRE Program. We thank **Mary McFarland, MLS** for help refining the search strategy; see the article for the authoritative acknowledgments.

For documentation or code contributions, see [CONTRIBUTING.md](./CONTRIBUTING.md). Use [GitHub Issues](https://github.com/reblocke/AOM-and-Bari-Surg-for-OSA-SRMA/issues) for questions and [SECURITY.md](./SECURITY.md) for security reports. Maintainer: Brian W. Locke.
