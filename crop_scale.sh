#!/bin/bash
# OFFSET1=35
# OFFSET2=25
if ( [ -z "${1}" ] || [ -z "${2}" ] )
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
if [ -z "${WIDTH}" ]
then
  WIDTH=1920
fi
if [ -z "${HEIGHT}" ]
then
  HEIGHT=1920
fi
if [ -z "${OFFSET1}" ]
then
  OFFSET1=35
fi
if [ -z "${OFFSET2}" ]
then
  OFFSET2=25
fi
START="${2}"
if [ -z "${3}" ]
then
  ary=(${2//:/ })
  m=${ary[0]}
  s=${ary[1]}
  m2=$m
  s2=$s
  s=$((s-OFFSET1))
  s2=$((s2+OFFSET2))
  if (( ${s} < 0 ))
  then
    s=$((s+60))
    m=$((m-1))
    if (( ${m} < 0 ))
    then
      m=0
      s=0
    fi
  fi
  if (( ${s2} >= 60 ))
  then
    s2=$((s2-60))
    m2=$((m2+1))
  fi
  sl=${#s}
  if (( ${sl} == 1 ))
  then
    s="0${s}"
  fi
  sl=${#s2}
  if (( ${sl} == 1 ))
  then
    s2="0${s2}"
  fi
  START="${m}:${s}"
  END="${m2}:${s2}"
else
  END="${3}"
fi
# -re - limits encoding speed to max 1x (simulates streaming)
echo "Cropping from $START to $END"
ffmpeg -y -threads 8 -ss "${START}" -to "${END}" -i "${1}" -c:v libx264 -vf "scale=${WIDTH}:${HEIGHT}:force_original_aspect_ratio=decrease,pad=${WIDTH}:${HEIGHT}:x=(${WIDTH}-iw)/2:y=(${HEIGHT}-ih)/2:color=black" -crf 22 -preset fast -r 100 -c:a aac -b:a 64k -ar 22050 "${PREFIX}${1}.mp4"
echo "Cropped from $START to $END"
