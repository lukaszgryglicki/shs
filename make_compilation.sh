#!/bin/bash
# MERGE=1
# OVERWRITE=1

OLDIFS=$IFS
IFS=$'\n'
ary=($(find . -depth 1 -type f -size +10M -iname '*.*'))
IFS=$OLDIFS
len=${#ary[@]}
i=0

if [ -z "${PREFIX}" ]
then
  PREFIX='cropped/crop_'
fi

while true
do
  f="${ary[$i]:2}"
  if (( $i == $len ))
  then
    break
  fi
  i=$((i+1))
  ofn="${PREFIX}${f}.mp4"
  if ( [ -z "${OVERWRITE}" ] && [ -f "${ofn}" ] )
  then
    echo "'${ofn}' already exists, skipping"
    continue
  fi
  sfn="${PREFIX}${f}.txt"
  if [ ! -f "${sfn}" ]
  then
    echo "($i/$len) mpv '$f'"
    mpv --really-quiet -window-scale=1.5 --osd-level=3 "${f}"
    result=$?
    if [ ! "${result}" = "0" ]
    then
      continue
    fi
  fi
  if [ -f "${sfn}" ]
  then
    crop=$(cat "$sfn")
    echo "'$f': read crop value '${crop}' from file"
  else
    echo -n "'$f': crop at (qu/r/m:ss/o1;o2;m:ss)? "
    read crop
    if ( [ ! "${crop}" = "qu" ] && [ ! "${crop}" = "r" ] )
    then
      echo "${crop}" > "$sfn"
    fi
  fi
  if [ "${crop}" = "qu" ]
  then
    break
  fi
  if [ "${crop}" = "" ]
  then
    continue
  fi
  if [ "${crop}" = "r" ]
  then
    i=$((i-1))
    continue
  fi
  a2=(${crop//;/ })
  if [ "${#a2[@]}" = "3" ]
  then
    export OFFSET1="${a2[0]}"
    export OFFSET2="${a2[1]}"
    crop="${a2[2]}"
  else
    export OFFSET1=''
    export OFFSET2=''
  fi
  a=(${crop//:/ })
  m=${a[0]}
  s=${a[1]}
  if ( [ -z "${m}" ] || [ -z "${s}" ] )
  then
    echo "you need to specify crop as 'm[m]:ss', retrying"
    rm -f "$sfn"
    i=$((i-1))
    continue
  fi
  # echo "OFFSET1=$OFFSET1, OFFSET2=$OFFSET2"
  echo "cropping '$f' at $crop"
  ./crop_scale.sh "${f}" "${crop}"
  result=$?
  if [ ! "${result}" = "0" ]
  then
    echo "failed cropping '$f' at $crop"
  else
    echo "cropped '$f' at $crop"
  fi
done
if [ ! -z "${MERGE}" ]
then
  ./merge_same_format.sh
fi
echo 'All done.'
