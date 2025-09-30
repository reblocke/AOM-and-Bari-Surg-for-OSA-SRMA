# Anti-obesity medications and bariatric surgery for obstructive sleep apnea (OSA): SRMA code & data

> Supporting code and data extraction tables for the systematic review, meta-analysis, and meta-regression accompanying the article **“The association of weight loss from anti-obesity medications or bariatric surgery and apnea–hypopnea index in obstructive sleep apnea”** (Obesity Reviews, 2024; 25(4):e13697).

## Links & persistent IDs
- **Article (publisher)**: https://doi.org/10.1111/obr.13697
- **PubMed**: https://pubmed.ncbi.nlm.nih.gov/38342767/
- **PubMed Central (open access)**: https://pmc.ncbi.nlm.nih.gov/articles/PMC11311115/
- **Systematic review registration (PROSPERO)**: https://www.crd.york.ac.uk/PROSPERO/view/CRD42022378853
- **This repository**: https://github.com/reblocke/AOM-and-Bari-Surg-for-OSA-SRMA

If you re-use this repository, please cite the paper (see **Cite this work** below) and, if you use or adapt the code directly, please also cite/acknowledge this repository.

## Cite this work
Preferred citation (article):

> Locke BW, Gomez-Lumbreras A, Tan CJ, Nonthasawadsri T, Veettil SK, Patikorn C, Chaiyakunapruk N. The association of weight loss from anti-obesity medications or bariatric surgery and apnea–hypopnea index in obstructive sleep apnea. *Obesity Reviews*. 2024;25(4):e13697. doi:10.1111/obr.13697.

For software citation metadata, see [`CITATION.cff`](./CITATION.cff). Many tools (including GitHub) can read this file directly.

## Quick start: reproduce the main analyses

> **Requirements**: Stata (SE/MP recommended). Analyses rely on one `.do` script and two Excel workbooks provided in this repository.

1. **Clone** this repository locally.
2. **Open Stata** and set the working directory to the repo root (replace the path with yours):
   ```stata
   cd "path/to/AOM-and-Bari-Surg-for-OSA-SRMA"
   ```
3. **Run the analysis** script:
   ```stata
   do "OSA Wt Loss SRMA.do"
   ```

### Outputs
- Forest/meta-analysis outputs and meta-regression plots are generated within Stata. To save figures programmatically, add `graph export` commands after the plotting steps in the `.do` file, for example:
  ```stata
  graph export "figures/fig3_ahi_change_by_intervention.png", width(2400) replace
  graph export "figures/fig4_meta_regression_ahi_vs_weightloss.png", width(2400) replace
  ```
- Tabular outputs can be exported as CSV/Excel using `outsheet`, `putexcel`, or `export excel` calls as desired.

> **Note**: The `.do` file assumes the Excel files below are present in the repository root. If you move them, update the corresponding `import excel` lines in the script.

## Data access
The study uses extracted, study-level data compiled by the authors. Two Excel workbooks are included here:

- **`Data Extraction Table.xlsx`** — primary extraction sheet with trial-level variables used for the meta-analysis/meta-regression (e.g., AHI at baseline and follow-up, percent weight change, follow-up duration, intervention and control definitions, etc.).
- **`ROB2_OSA SRMA.xlsx`** — risk-of-bias 2 (RoB2) assessments for included randomized trials, captured at the outcome level per study.

There are no patient-level data or protected health information in this repository.

## Environment
- **Software**: Stata (SE/MP recommended). The `.do` file uses standard Stata commands for meta-analysis and meta-regression.
- **Operating systems**: Any OS supported by Stata (Windows/macOS/Linux).
- **Reproducibility tips**: To capture exact commands and output, consider running Stata in batch mode with logging enabled, e.g.:
  ```bash
  # Windows (StataMP)
  "C:\Program Files\Stata18\StataMP-64.exe" /e do "OSA Wt Loss SRMA.do"
  # macOS (StataMP)
  /Applications/Stata/StataMP.app/Contents/MacOS/StataMP -b do "OSA Wt Loss SRMA.do"
  ```

## Repository layout
```
.
├── OSA Wt Loss SRMA.do                # End-to-end analysis (meta-analysis + meta-regression)
├── Data Extraction Table.xlsx         # Study-level extraction data
├── ROB2_OSA SRMA.xlsx                 # Risk-of-bias (RoB2) assessments
├── LICENSE                            # MIT License (applies to code in this repository)
└── (add) figures/ and outputs/        # Recommended folders for saved figures/tables
```

## Workflow overview
1. Import extracted data from the Excel workbooks.
2. Compute study-level effect sizes (AHI change and/or percent change) and variances per trial arm.
3. Conduct random-effects meta-analyses of AHI change by intervention and class.
4. Perform meta-regression of % weight loss vs. AHI change at longest follow‑up.
5. Sensitivity analyses (e.g., remove high RoB trials) and subgroup checks.
6. Export figures and summary tables.

## Results mapping (paper ↔ code)
| Paper item | Where to generate | How to save |
|---|---|---|
| **Figure 3** – Random-effects meta-analysis of AHI change by intervention/class | `OSA Wt Loss SRMA.do` (forest/meta section) | Add `graph export "figures/fig3_ahi_change_by_intervention.png", replace` after the plot command |
| **Figure 4** – Meta-regression of % weight loss vs. AHI change | `OSA Wt Loss SRMA.do` (meta-regression section) | Add `graph export "figures/fig4_meta_regression_ahi_vs_weightloss.png", replace` |
| Supplemental figures/tables (S10–S17 etc.) | same script, respective sections | Export with meaningful file names into `figures/` or `outputs/` |

*(If you prefer, create separate `.do` files per figure and call them from a master script—this makes mapping even clearer.)*

## License
- **Code** in this repository is licensed under the [MIT License](./LICENSE).
- **Data extraction tables** are provided to support reproducibility of the published manuscript. If you reuse the compiled tables, please **cite the paper** above. If you redistribute modified versions, include a note describing changes.

## Funding & acknowledgments
This work was supported by the **National Institutes of Health** (Ruth L. Kirschstein National Research Service Award **5T32HL105321**) and the **American Thoracic Society ASPIRE Program**. We thank **Mary McFarland, MLS** for assistance refining the search strategy. See the article’s Acknowledgments/Funding for the authoritative record.

## Contributing and governance
We welcome issues and pull requests that improve clarity, reproducibility, or documentation. Please see:
- [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md)
- [`SECURITY.md`](./SECURITY.md)

## Maintainers / contact
- Maintainer: **Brian W. Locke** · brian.locke@hsc.utah.edu
- Please use [GitHub Issues](https://github.com/reblocke/AOM-and-Bari-Surg-for-OSA-SRMA/issues) for bug reports and questions related to the repository.
