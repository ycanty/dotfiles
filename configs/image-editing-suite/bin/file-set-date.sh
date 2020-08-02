#!/bin/bash

# Set the filesystem date of the given file from the filename
# representing a date/time.
# 
# Arguments:
# 1) file to process
# 2) optional date/time format pattern used by the filename

FILE=$1
PATTERN=${2:-%F-%H%M%S}

if [[ ! -r "${FILE}" ]]
then
   echo "${FILE}: Not readable"
   exit 1
fi

FILENAME="$(basename "${FILE}" | sed -e s/\\..*$//)"

if [ -z "${FILENAME}" ]
then
   continue
fi
TIME=$(date -jf "${PATTERN}" "${FILENAME}" '+%Y%m%d%H%M.%S' 2>&1)

if [[ $? != 0 ]]
then
   echo "[ERROR] ${FILE}: Unable to extract date from filelname using pattern '${PATTERN}'"
   exit 1
fi

touch -t $TIME "${FILE}"
