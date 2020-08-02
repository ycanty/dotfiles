#!/bin/bash

# Copy all metadata from one file to another file.
# args:
# srcimage targetimage

srcdir="$1"

find . -type f -not -name ".*" | while read file
do
echo "FILE=${file}"
done

# exiftool -progress -F -P -overwrite_original -use MWG -TagsFromFile "-all:all" "$@"
