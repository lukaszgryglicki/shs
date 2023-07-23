#!/bin/bash
if ( [ -z "$1"] || [ -z "$2" ] )
# ffmpeg -i DSCF6425.MOV -c:v libx265 -crf 26 -preset medium -c:a aac -b:a 128k pass1.mp4
then
  echo "$0: you need to specify both input and output files"
  exit 1
fi
ffmpeg -i "$1" -c:v libx265 -crf 26 -preset medium -c:a aac -b:a 128k "$2"
