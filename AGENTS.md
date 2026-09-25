# AGENTS

## Project purpose
This repository contains the Stata analysis script and study-level extraction workbooks for the systematic review, meta-analysis, and meta-regression on weight loss interventions and apnea-hypopnea index in obstructive sleep apnea.

## Public-data constraints
- The repository contains study-level extraction tables, not patient-level data or PHI.
- Preserve the article citation and repository citation metadata when reusing the workbooks or code.
- Do not copy publisher-formatted article text into the repository. Link to the DOI, PubMed, and PubMed Central records instead.

## How to orient quickly
- Start with `README.md` for links, citation, data-access notes, workflow, and paper-to-code mapping.
- Use `CITATION.cff` for structured citation metadata.
- The main analysis script is `OSA Wt Loss SRMA.do`.
- The computational workbook input is `Data Extraction Table.xlsx` (`Sheet1`); `ROB2_OSA SRMA.xlsx` is supporting RoB material and is not imported by the do-file.

## Reproduction workflow
Use the source-inspected [README invocation](./README.md#run-the-existing-script) only in a new disposable checkout with licensed Stata 18 and a previously unused result root. The script accepts optional `workbook_dir output_root` arguments (defaults: `.`, `Results and Figures`). It reads only `Data Extraction Table.xlsx` from `workbook_dir`, copies the do-file from the working directory, opens a dated log with `replace`, and saves derived data with `replace` under `outputs/stata` relative to that working directory. It declares figure exports under the dated result directory. See the [README output boundary](./README.md#output-and-verification-boundary): current graph-export paths have malformed `results_dir` macro delimiters. Do not claim successful figure creation or publication reproduction without a separate code fix and execution check.

## Workbook structure
- `Data Extraction Table.xlsx`: study-level trial and intervention data, including DOI, intervention class, sample size, weight measures, AHI measures, follow-up, and analysis variables.
- `ROB2_OSA SRMA.xlsx`: risk-of-bias 2 judgments by study and RoB2 domain.

## Verification before publishing changes
- Run `git diff --check`.
- Validate `CITATION.cff` as YAML after citation edits.
- If the Stata script is run, do not commit generated figures, logs, or exploratory exports unless a release explicitly requires them.
