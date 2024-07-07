#!/bin/bash
# CONTRAST=1
# QUALITY=90
# PREFIX=./out/
# OVERWRITE=1
# CM='1,0,0,0,1,0,0,0,1'
# OPTS='-separate -enhance -auto-gamma -contrast-stretch 5%x1% -equalize -normalize -white-balance -combine -quality 95%'
# ONLY_OPTS=1
# matrix: 0.4, 0, 0,
#         0.4, 1, 0,
#         0.2, 0, 1
base=`basename "${1}"`
jpg=`echo "${base}" | cut -f 1 -d .`.jpg
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
  QUALITY="90"
fi
if [ -z "${CM}" ]
then
  CM='1,0,0,0,1,0,0,0,1'
fi
if [ -z "${OPTS}" ]
then
  echo "magick ${1} -color-matrix ${CM} -separate -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -quality ${QUALITY}% ${jpg}"
  time magick "${1}" -color-matrix "${CM}" -separate -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine -quality "${QUALITY}%" "${jpg}"
else
  if [ -z "${ONLY_OPTS}" ]
  then
    echo "magick ${1} -color-matrix ${CM} -separate ${OPTS} -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -quality ${QUALITY}% ${jpg}"
    time magick "${1}" -color-matrix "${CM}" -separate ${OPTS} -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine -quality "${QUALITY}%" "${jpg}"
  else
    echo "magick ${1} ${OPTS} ${jpg}"
    time magick "${1}" ${OPTS} "${jpg}"
  fi
fi
