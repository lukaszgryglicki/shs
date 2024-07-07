#!/bin/bash
# CONTRAST=1
# EXT=jpg
# QUALITY=85
# DEPTH=8 (you can specify other for image formats that support it)
# REV='' (set to 1 to do RGB -> BGR)
# PREFIX=./out/
# OVERWRITE=1
# CM='1,0,0,0,1,0,0,0,1'
# OPTS='-separate -enhance -auto-gamma -contrast-stretch 5%x1% -equalize -normalize -white-balance -combine -depth 12 -quality 95%'
# ONLY_OPTS=1
# matrix: 0.4, 0, 0,
#         0.4, 1, 0,
#         0.2, 0, 1
for f in "$*"
do
  base=$(basename "${1}")
  if [ -z "${EXT}" ]
  then
    EXT=jpg
  fi
  jpg="$(echo "${base}" | cut -f 1 -d .).${EXT}"
  if [ ! -z "${PREFIX}" ]
  then
    jpg="${PREFIX}${jpg}"
  fi
  if [ "${jpg}" = "${1}" ]
  then
    jpg="mag_${jpg}"
  fi
  if [ -f "${jpg}" ]
  then
    echo "${jpg} already exists"
    if [ -z "${OVERWRITE}" ]
    then
      echo "exiting"
      exit 1
    else
      echo "overwriting ${jpg}"
    fi
  fi
  if [ -z "${CONTRAST}" ]
  then
    CONTRAST="1"
  fi
  if [ -z "${QUALITY}" ]
  then
    QUALITY="85"
  fi
  if [ -z "${DEPTH}" ]
  then
    DEPTH="8"
  fi
  if [ -z "${CM}" ]
  then
    if [ -z "${REV}" ]
    then
      CM='1,0,0,0,1,0,0,0,1'
    else
      CM='0,0,1,0,1,0,1,0,0'
    fi
  fi
  if [ -z "${OPTS}" ]
  then
    echo "magick ${1} -color-matrix ${CM} -separate -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -quality ${QUALITY}% -depth ${DEPTH} ${jpg}"
    time magick "${1}" -color-matrix "${CM}" -separate -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine -quality "${QUALITY}%" -depth "${DEPTH}" "${jpg}"
  else
    if [ -z "${ONLY_OPTS}" ]
    then
      echo "magick ${1} -color-matrix ${CM} -separate ${OPTS} -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -quality ${QUALITY}% -depth ${DEPTH} ${jpg}"
      time magick "${1}" -color-matrix "${CM}" -separate ${OPTS} -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine -quality "${QUALITY}%" -depth "${DEPTH}" "${jpg}"
    else
      echo "magick ${1} ${OPTS} ${jpg}"
      time magick "${1}" ${OPTS} "${jpg}"
    fi
  fi
done
