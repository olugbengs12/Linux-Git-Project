#!/bin/bash
# ---------------------------------------------------------------
# Moves all CSV and JSON files from a source folder into json_and_CSV
# ---------------------------------------------------------------

# The folder we are taking files from.
SOURCE="source_files"

# The folder we are moving them into.
DESTINATION="json_and_CSV"

echo "Moving CSV and JSON files from $SOURCE to $DESTINATION..."

# Create the destination folder if it does not already exist.
mkdir -p "$DESTINATION"

# Stop if the source folder is missing. -d checks for a directory.
if [ ! -d "$SOURCE" ]; then
    echo "ERROR: the folder $SOURCE does not exist."
    exit 1
fi

# Counter so we can report how many files were moved.
count=0

# Loop over every .csv and .json file in the source folder.
# The * is a wildcard meaning "any name".
for file in "$SOURCE"/*.csv "$SOURCE"/*.json; do

    # If no file matches, bash passes the pattern through literally,
    # so we check the file really exists before moving it.
    if [ -f "$file" ]; then
        mv "$file" "$DESTINATION"/
        echo "Moved: $file"
        count=$((count + 1))    # add 1 to the counter
    fi
done

echo "Done. $count file(s) moved into $DESTINATION."