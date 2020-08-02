#!/bin/bash
# Scans all .xmp files in the current directory and moves them next to their
# image file in the given destination directory

DIR=$1

if [[ -z "${DIR}" ]]
then
    echo "Missing image directory"
    exit 1
fi

i=$(find . -type f -name '*.xmp' | wc -l)

find . -type f -name '*.xmp' | sort | while read xmp
do
    img=$(basename "${xmp}" .xmp)
    file=$(find "${DIR}" -name "${img}.*" -not -path '*/.BridgeSharedCache/*')
    if [[ -z "${file}" ]]
    then
        echo "${i}: NOT FOUND: ${xmp}"
        i=$((i-1))
        continue
    fi
    destdir=$(dirname "$file")
    echo ${i}: mv "$xmp" "$destdir"/.
    mv "$xmp" "$destdir"/.
    i=$((i-1))
done