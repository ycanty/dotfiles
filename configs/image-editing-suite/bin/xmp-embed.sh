#!/bin/bash

# Embed XMP sidecar metadata in all files in the given files or directories.
# Recommended: Run xmp-fix.sh on all XMP files before running this script.

function usage() {
    cat<<EOF
$0 [-r] file|dir [file|dir]...
EOF
}

function embed() {
    local file="$1"

    if [[ -f "${file}" ]]
    then
        exiftool -progress -P -F -use MWG --ext xmp -overwrite_original -tagsfromfile %d%f.xmp -all:all "${file}"
        return $?
    fi

    if [[ -d "${file}" ]]
    then
        exiftool -progress -P -F -use MWG --ext xmp -overwrite_original -tagsfromfile %d%f.xmp -all:all ${RECURSE} "${file}"
        return $?
    fi
}

RECURSE=""

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -r|--recurse)
        RECURSE="-r"
        shift
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        *)
        embed "${key}"
        shift
        ;;
    esac
done
