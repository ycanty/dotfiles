#!/bin/bash

# Rename media files using the date/time at which the picture was taken

# Could also be done with one exiftool command:
# https://gist.github.com/jmuspratt/3680d45b0c12f8b32093
exiftool -use MWG '-filename<DateTimeOriginal' -d %Y-%m-%d-%H%M%S%%-c.%%e "$@"