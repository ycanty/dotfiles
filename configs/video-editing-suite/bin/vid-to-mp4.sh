#!/bin/bash

PRESET="Apple 1080p30"

find . -type f -iname "*.avi" -o -iname "*.mov" -o -iname "*.3gp" | while read FILE
do
    OUTFILE="${FILE%.*}.mp4"
    echo "Creating $OUTFILE"
    /Applications/HandbrakeCLI --preset-import-gui  -Z "${PRESET}" -i "${FILE}" -o "${OUTFILE}" < /dev/null

    if [ $? == 0 ]
    then
        rm -f ${FILE}
    fi
done
