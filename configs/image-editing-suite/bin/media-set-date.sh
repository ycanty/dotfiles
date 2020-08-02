#!/bin/bash

# Sets creation dates in the image or video metadata using the first argument as the new date/time
# Examples:
# 2019:12:29 16:05:00-05:00
# 2019-12-29-160500-0500

# Note that Apple photos needs the timezone to interpret the date correctly in video files

DATE=$1
shift

exiftool -progress -F -P -overwrite_original -use MWG "-datetimeoriginal=${DATE}" "$@"
