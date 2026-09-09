# CoreDataEngineers — Linux & Git Exercise

A Bash-based ETL pipeline and file management scripts for the CDE Linux and Git assignment.

## Overview

`cde.sh` downloads the New Zealand Annual Enterprise Survey 2023 dataset,
selects four columns, and loads the result into a Gold directory.
`move.sh` moves CSV and JSON files into a single folder.

## Folder Structure

| Folder | Contents |
|---|---|
| `raw/` | Downloaded source CSV
| `Transformed/` | `2023_year_finance.csv` after column selection |
| `Gold/` | Final loaded output |
| `source_files/` | Sample CSV and JSON files for task 3 |
| `json_and_CSV/` | Destination for moved CSV and JSON files |

## Running the ETL script

```bash
chmod +x cde.sh
./etl.sh
```

The script runs in three stages and prints a confirmation after each:

1. **Extract** — downloads the CSV into `raw/` using a URL held in the
   `CSV_URL` environment variable, then verifies the file exists.
2. **Transform** — keeps only `year`, `Value`, `Units` and `variable_code`,
   renaming `Variable_code` to `variable_code`, and writes
   `Transformed/2023_year_finance.csv`.
3. **Load** — copies the transformed file into `Gold/` and verifies it.

If any stage fails, the script prints an error and exits.

## Scheduling with cron

The script is scheduled to run daily at midnight:
0 0 * * * cd /home/gbenga/Linux-Git-Project && ./etl.sh >> /home/gbenga/Linux-Git-Project/etl.log 2>&


The five fields are minute, hour, day of month, month, and day of week,
so `0 0 * * *` means minute 0 of hour 0 — every day at 12:00 AM.
The job changes into the project directory first because cron runs from
the user's home directory, and output is appended to `etl.log`.

Installed with `crontab -e` and verified with `crontab -l`.

## Moving CSV and JSON files

```bash
chmod +x move.sh
./move.sh
```

Moves every `.csv` and `.json` file from `source_files/` into
`json_and_CSV/`, handling one or many files, and reports how many
were moved.

## Notes,design decisions and Assumptions

**Column selection uses `gawk` rather than `cut`.** Some values in the
source file contain commas inside quoted fields — for example
`"Sales, government funding, grants and subsidies"` in `Variable_name`,
which sits before the `Value` column. Splitting on commas with `cut`
would shift the following fields and return the wrong data with no
error. `gawk` with `FPAT` treats a quoted string as a single field,
which keeps the columns aligned.

**Header casing.** The source file's first column is `Year`, but the
specification asks for `year`. The output header uses the lowercase
form requested in the spec.

**Environment on WSL.** This was developed on WSL, where cron does not
start automatically and only runs while WSL is active. The service is
started with `sudo service cron start`.

**Git version control.** I used Ubuntu on WSL. I had to setup my SSH for git,
did the connection before I was able to push to the online repo.

## Requirements

- Bash
- `curl`
- `gawk` (`sudo apt install gawk`)