#!/bin/bash

# Display a count of files by extension in the given dir and below
# Skips hidden files and directories

DIR=${1:-.}

find "${DIR}" -type f -not -path '*/.*' | sed 's/.*\.//' | tr '[A-Z]' '[a-z]' | sort | uniq -c | sort -r -n
