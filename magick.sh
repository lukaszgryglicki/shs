#!/bin/bash
# CONTRAST=1
# JP2='' (set to 1 to use JEPG2000)
# QUALITY=85 (for JPG) 40 (For JP2)
# DEPTH=12 (only when JP2 (JPEG2000) is used otherwise it is 8 (only possible for normal JPG)
# REV='' (set to 1 to do RGB -> BGR)
# PREFIX=./out/
# OVERWRITE=1
# CM='1,0,0,0,1,0,0,0,1'
# OPTS='-separate -enhance -auto-gamma -contrast-stretch 5%x1% -equalize -normalize -white-balance -combine -depth 12 -quality 95%'
# ONLY_OPTS=1
# matrix: 0.4, 0, 0,
#         0.4, 1, 0,
#         0.2, 0, 1
base=`basename "${1}"`
if [ -z "${JP2}" ]
then
  jpg=`echo "${base}" | cut -f 1 -d .`.jpg
else
  jpg=`echo "${base}" | cut -f 1 -d .`.jp2
fi
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
  if [ -z "${JP2}" ]
  then
    QUALITY="85"
  else
    QUALITY="41"
  fi
fi
if [ -z "${DEPTH}" ]
then
  if [ -z "${JP2}" ]
  then
    DEPTH="8"
  else
    DEPTH="12"
  fi
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
