#!/bin/bash
# The line above tells Linux to run this file using the bash shell.
# ---------------------------------------------------------------
# CDE script: downloads a CSV, keeps 4 columns, saves the result.
# ---------------------------------------------------------------


# --------- SET THE URL AS AN ENVIRONMENT VARIABLE ------------------

# "export" creates an environment variable that the rest of the script can use.
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"


# ------------- STEP 1: EXTRACTION ------------------

echo "STEP 1: EXTRACTION - downloading the file..."

# Create a folder called "raw".
mkdir raw

# Download the file into the raw folder.
#curl lets bash download files from the internet.
# -o says where to save it. $CSV_URL is the variable we set above.
curl -o raw/survey.csv "$CSV_URL"

# Check the file is really there.
# -f means "does this file exist?"
if [ -f raw/survey.csv ]; then
    echo "SUCCESS: file saved in the raw folder."
else
    echo "ERROR: file was not downloaded."
    exit 1          # exit 1 stops the script because something went wrong.
fi                  #fi closes the if statement.


# ------------- STEP 2: TRANSFORMATION -------------------

echo "STEP 2: TRANSFORMING - selecting columns..."

# Create the folder for the transformed file.
mkdir Transformed

# In the downloaded file the columns are numbered like this:
#   1 = Year        5 = Units        6 = Variable_code        9 = Value
# We want to keep only those four.
# We use gawk instead of cut because some values contain commas inside e.g column the Industry_code_ANZSIC06
# quotes (e.g. "Sales, government funding"), and cut would split them wrongly.
# Gawk Treats a quoted value as one field
# NR makes the headers row print the new column names as the first row of the new file.
gawk 'BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")"; OFS = "," }                 
      NR == 1 { print "year", "Value", "Units", "variable_code"; next }
                { print $1, $9, $5, $6 }' \
      raw/survey.csv > Transformed/2023_year_finance.csv

# Check the transformed file was created.
if [ -f Transformed/2023_year_finance.csv ]; then
    echo "SUCCESS: file saved in the Transformed folder."
else
    echo "ERROR: transform failed."
    exit 1
fi


# ----------------------- STEP 3: LOAD ----------------------------------------------

echo "STEP 3: LOAD - copying to the Gold folder..."

# Create the Gold folder.
mkdir Gold

# Copy the transformed file into it.
cp Transformed/2023_year_finance.csv Gold/

# Check it copied.
if [ -f Gold/2023_year_finance.csv ]; then
    echo "SUCCESS: file saved in the Gold folder."
else
    echo "ERROR: load failed."
    exit 1
fi

echo "CDE ETL process complete."