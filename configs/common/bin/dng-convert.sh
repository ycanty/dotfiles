#!/bin/bash

# CLI mode of Adobe DNG Converter
# https://wwwimages2.adobe.com/content/dam/acom/en/products/photoshop/pdfs/dng_commandline.pdf

# Note: the app requires all files to be specified with their full absolute path

function usage() {
    cat<<EOF
$0 file [...]
$0 [-r] dir
EOF
}

realpath() {
    files="$@"

    for f in "${files}"
    do
        [[ "${f}" = "/*" ]] && echo "${f}" || echo "$PWD/${f#./}"
    done
}

function convert() {
    local files=$(realpath "$@")
    open -a "/Applications/Adobe DNG Converter.app/Contents/MacOS/Adobe DNG Converter" --args -c -p1 -fl "${files}"
}

function convert_files() {
    local files="$@"
    convert "${files}"
}

function convert_dir {
    local dir="$1"
    local recurse="$2"

    local find_opts=""

    if [[ -n "${recurse}" ]]
    then
        find_opts="-depth 1"
    fi
    
    find "${dir}" -type f -not -path "*/.*" ${find_opts} | while read file
    do
        convert_files "${file}"
    done
}

set -e

if [[ $# == 0 ]]
then
    usage
    exit 0
fi

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -r|--recurse)
        shift
        convert_dir "$@" "yes"
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        *)
        if [[ -d "${key}" ]]
        then
            convert_dir "${key}"
        else
            convert_files "${key}"
        fi
        shift
        ;;
    esac
done
