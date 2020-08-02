set -e

function convert() {
  local F="$1"
  local output="${F//.mp4/rotated.mp4}"
  echo "$F --> ${output}"
#  continue
  ffmpeg -nostdin -y -i "${F}" -c copy -metadata:s:v:0 rotate=-90 "${output}"
  if [ $? == 0 ]
  then
    mv -f "${output}" "${F}"
  fi
}

find . -type f -name '*.mp4' | while read F
do
  echo "$F"
  convert "$F"
done
