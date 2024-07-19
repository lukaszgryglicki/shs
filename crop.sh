#!/bin/bash
if ( [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] )
then
  echo "${0}: usage: ${0} filename from to"
  echo "${0}: example:"
  echo "${0} file.mp4 00:00:05 00:10:05"
  exit 1
fi
if [ -z "${PREFIX}" ]
then
  PREFIX='cropped/crop_'
fi
ffmpeg -i "${1}" -vcodec copy -acodec copy -ss "${2}" -to "${3}" "${PREFIX}${1}"
