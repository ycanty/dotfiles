#!/bin/bash

# Copy all metadata from one file to another file.
# args:
# srcimage targetimage

exiftool -progress -F -P -overwrite_original -use MWG -TagsFromFile "-all:all" "$@"
