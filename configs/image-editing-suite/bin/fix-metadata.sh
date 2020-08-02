#!/bin/bash

# Burn files metadata in current dir and all subdirs
# by reading XMP sidecar.  Assumes filename format is YY-MM-DD_hh-mm-ss

# First fix all xmp sidecar files

# echo "### Fixing xmp sidecar files"
# count=$(find . -type f -name '*.xmp' -not -path '*/.*' | wc -l)
# find . -type f -name '*.xmp' -not -path '*/.*' | while read FILE
# do
#     echo "${count}: Fixing ${FILE}"
#     xmp-fix.sh "${FILE}"
#     count=$((count-1))
# done

echo
echo "### Embedding XMP sidecar metadata into media files"
xmp-embed.sh .

echo
echo "### Fixing video metadata from file names"
vid-set-date.sh

echo
echo "### Fixing file system date/time of video files"
count=$(find . -type f -iname '*.mp4' -o -iname '*.mov' -not -path '*/.*' -not -path '*/*.xmp' | wc -l)
find . -type f -iname '*.mp4' -o -iname '*.mov' -not -path '*/.*' -not -path '*/*.xmp' | while read FILE
do
    echo "${count}: Setting date/time on ${FILE}"
    file-setdate.sh "${FILE}"
    count=$((count-1))
done

