#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to provide input file name"
  exit 1
fi
for f in "$@"
do
  o="${f%.flac}.mp3"
  if [ -z "${REMOVE_FLAC}" ]
  then
    ffmpeg -i "$f" -ab 320k -map_metadata 0 -id3v2_version 3 "$o"
  else
    ffmpeg -i "$f" -ab 320k -map_metadata 0 -id3v2_version 3 "$o" && rm -f "$f"
  fi
done
