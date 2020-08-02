#!/bin/bash

DIR=$1
FILE=$2

/Applications/VLC.app/Contents/MacOS/VLC dvdsimple://${DIR} --sout file/ps:- | /Applications/HandBrakeCLI -Z iPad -i - -o ${FILE}
