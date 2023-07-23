#!/bin/bash
if ( [ -z "$1"] || [ -z "$2" ] )
then
  echo "$0: you need to specify both input and output files"
  exit 1
fi
ffmpeg -y -i "$1" -c:v libx265 -preset medium -b:v 50000k -x265-params pass=1 -an -f null /dev/null &&\
ffmpeg -i "$1" -c:v libx265 -preset medium -b:v 50000k -x265-params pass=2 -c:a aac -b:a 128k "$2"
