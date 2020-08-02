#!/bin/bash

# Needs: brew install xml-coreutils

# Fix sidecar files output by Mac Photos app
# The tags GPSLatitudeRef and GPSLongitudeRef only contain cardinal points
# but that's not valid for exiftool.  So we merge these at the end
# of GPSLatitude and GPSLongitude tags

# To use recursively:
# find . -type f -name '*.xmp' -not -path '*/.*' | while read FILE
# do
#     echo "${count}: Fixing ${FILE}"
#     xmp-fix.sh "${FILE}"
#     count=$((count-1))
# done


function usage() {
    echo <<EOF
    "$0 [sidecar.xmp]"
    "Reads from stdin if file is not provided"
EOF
}

function get_ref() {
    local file=$1
    local tag=$2

    ref=$(xml-printf '%s' "${file}" :/x:xmpmeta/rdf:RDF/rdf:Description/exif:${tag} 2> /dev/null)

    if [[ ! -z "${ref}" ]]
    then
        ref=" ${ref}"
    fi

    echo "${ref}"
}

function fix_tag() {
    read content
    local file=$1
    local src_tag=$2
    local dst_tag=$3

    local src_tag_val=$(get_ref "${file}" "${src_tag}")

    if [[ -z "${src_tag_val}" ]]
    then
        cat "${file}"
        return
    fi

    echo ${content} | xml-sed "a ${src_tag_val}" :/x:xmpmeta/rdf:RDF/rdf:Description/exif:${dst_tag} | xml-rm :/x:xmpmeta/rdf:RDF/rdf:Description/exif:${src_tag}
}

function fix_file() {
    local file="$1"

    local tmpfile=$(mktemp)
    cat "${file}" > "${tmpfile}"

    local long_ref="$(get_ref "${tmpfile}" GPSLongitudeRef)"
    local lat_ref="$(get_ref "${tmpfile}" GPSLatitudeRef)"

    if [[ -z "${long_ref}" && -z "${lat_ref}" ]]
    then
        exit 0
    fi

    set -o pipefail

    local tmpout=$(mktemp)

    xml-rm "${tmpfile}" :/x:xmpmeta/rdf:RDF/rdf:Description/exif:GPSLongitudeRef :/x:xmpmeta/rdf:RDF/rdf:Description/exif:GPSLatitudeRef | \
        xml-sed "a${long_ref}" :/x:xmpmeta/rdf:RDF/rdf:Description/exif:GPSLongitude | \
        xml-sed "a${lat_ref}" :/x:xmpmeta/rdf:RDF/rdf:Description/exif:GPSLatitude > "${tmpout}"

    if [[ $? == 0 ]]
    then
        mv "${tmpout}" "${file}"
    fi

    rm -f "${tmpfile}" "${tmpout}"
}

FILE=${1:-/dev/stdin}

if [[ ! -r "${FILE}" ]]
then
    usage
    exit 1
fi

fix_file "${FILE}"
