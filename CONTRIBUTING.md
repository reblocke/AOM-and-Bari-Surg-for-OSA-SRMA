# Contributing to this project

Thank you for your interest in improving the reproducibility and clarity of this research repository. Contributions are welcomed in the form of issues and pull requests.

## Ways to contribute
- **Documentation**: clarify the README, add comments to the Stata `.do` file, or improve the description of columns in the Excel files.
- **Reproducibility**: review the existing `graph export` commands or propose table exports, split long scripts into smaller figure-specific scripts, or add a top-level master script.
- **Bug fixes**: identify and fix errors in the `.do` file (please describe the fix and how you tested it).
- **Packaging**: add optional automation (e.g., batch mode instructions for Stata on Windows/macOS/Linux).

## Getting started
1. **Open an issue** to describe the change you propose (bug, enhancement, or documentation).
2. **Fork** the repository and create a feature branch: `git checkout -b feat/short-description`.
3. For code changes, **run the analysis** locally when the required Stata environment is available; for documentation changes, report source inspection separately from execution.
4. **Submit a pull request (PR)** referencing the issue.

## Coding and data guidelines
- Keep analyses **scripted**. Avoid manual steps; prefer code over interactive clicking.
- For Stata code:
  - Favor clear section headers and comments.
  - Use meaningful variable names; avoid overwriting raw columns.
  - Prefer **relative paths** so the project runs from the repo root.
- For data changes:
  - Do not include any patient-identifiable information.
  - If adding new extracted studies, review the extraction table and supporting RoB2 workbook together and document sources. The analysis imports only `Sheet1` of the extraction table.

## Re-running checks
Please include a short paragraph in your PR describing the exact checks performed, their input/output scope, and what remains unverified. Use the README's [Stata invocation](./README.md#run-the-existing-script) and [output map](./README.md#output-and-verification-boundary) when checking arguments, the dated log root, and the separate derived-data path. The do-file declares graph exports under the dated result directory, but its current macro delimiters need a separate code fix before their paths can be verified.

## Reporting issues and asking questions
- Use [GitHub Issues](../../issues). Include:
  - OS and Stata version
  - Exact commands you ran
  - Any error messages (copy/paste or attach log)

## Licensing
By contributing, you agree that your contributions will be licensed under the repository’s [MIT License](./LICENSE).

## Citation
If your contribution leads to published work using this code or data extraction, please cite the paper (see README) and this repository.
