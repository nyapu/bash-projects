#!/bin/bash
# ------------------------------------------------------------
# Script Name: archive_logs.sh
# Purpose    : Find large/old files in a given directory,
#              compress them with gzip, and move them to archive.
# Author     : Nyapu
# ------------------------------------------------------------

# Base directory where logs or files are stored
BASE=/home/nyapu/Desktop/bashS/Proj1_Archive_older_logs

# Number of days old a file must be before being archived
# Example: 1 = files older than 1 day
DAYS=1

# How deep to search inside the BASE directory
# Example: 1 = only inside BASE, not deeper subfolders
DEPTH=1

# ------------------------------------------------------------
# Step 1: Check if the base directory exists
# ------------------------------------------------------------
if [ ! -d "$BASE" ]; then
    echo "❌ Directory doesn't exist: $BASE"
    exit 1
fi

# ------------------------------------------------------------
# Step 2: Create an "archive" subfolder if it doesn't exist
# ------------------------------------------------------------
if [ ! -d "$BASE/archive" ]; then
    mkdir "$BASE/archive"
    echo "📁 Created archive folder: $BASE/archive"
fi

# ------------------------------------------------------------
# Step 3: Find and process files
# -maxdepth $DEPTH   → how deep to search
# -type f            → only files
# -size +10M         → only files larger than 10 MB
# -mtime +$DAYS      → only files older than $DAYS days
# -print0            → output file names with NULL separator
#                      (so names with spaces are handled safely)
# ------------------------------------------------------------
find "$BASE" -maxdepth $DEPTH -type f -size +10M -mtime +$DAYS -print0 |
while IFS= read -r -d '' file   # loop through each file found
do
    echo "📦 Archiving: $file"

    # Step 3a: Compress the file with gzip
    # If gzip fails, exit with error code
    gzip "$file" || exit 1

    # Step 3b: Move the compressed file (*.gz) into archive folder
    # If mv fails, exit with error code
    mv "$file.gz" "$BASE/archive/" || exit 1
done
#Highlighted why -print0 and while IFS= read -r -d '' are used (safe for spaces in filenames).
# ------------------------------------------------------------
# Step 4: Final message
# ------------------------------------------------------------
echo "✅ Archiving completed successfully! Files are in: $BASE/archive"

