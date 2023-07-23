#!/bin/bash
# CONTRAST=1
# QUALITY=90
# PREFIX=./out/
# OVERWRITE=1
# CM='1,0,0,0,1,0,0,0,1'
# OPTS='-separate -enhance -auto-gamma -contrast-stretch 5%x1% -equalize -normalize -white-balance -combine'
# HOPTS='-b 12 -quality 90%'
# HBITS=12
# HFN=heic|avif
# LL=1
# ONLY_OPTS=1
# matrix: 0.4, 0, 0,
#         0.4, 1, 0,
#         0.2, 0, 1
base=`basename "${1}"`
png=`echo "${base}" | cut -f 1 -d .`.png
if [ -z "${HFN}" ]
then
  HFN="heic"
fi
heif=`echo "${base}" | cut -f 1 -d .`".${HFN}"
if [ ! -z "${PREFIX}" ]
then
  png="${PREFIX}${png}"
fi
if [ "${png}" = "${1}" ]
then
  png="mag_${png}"
fi
if [ -f "${png}" ]
then
  echo "${png} already exists"
  if [ -z "${OVERWRITE}" ]
  then
    echo "exiting"
    exit 1
  else
    echo "overwriting ${png}"
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
if [ -z "${HBITS}" ]
then
  HBITS="12"
fi
if [ -z "${OPTS}" ]
then
  echo "magick ${1} -color-matrix ${CM} -separate -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -depth 16 ${png}"
  time magick "${1}" -color-matrix "${CM}" -separate -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine -depth 16 "${png}"
else
  if [ -z "${ONLY_OPTS}" ]
  then
    echo "magick ${1} -color-matrix ${CM} -separate ${OPTS} -contrast-stretch ${CONTRAST}%x${CONTRAST}% -combine -depth 16 ${png}"
    time magick "${1}" -color-matrix "${CM}" -separate ${OPTS} -contrast-stretch "${CONTRAST}%x${CONTRAST}%" -combine  -depth 16 "${png}"
  else
    echo "magick ${1} ${OPTS} -depth 16 ${png}"
    time magick "${1}" ${OPTS} -depth 16 "${png}"
  fi
fi
if [ -z "${HOPTS}" ]
then
  if [ -z "$LL" ]
  then
    HOPTS="-b ${HBITS} -q ${QUALITY}"
  else
    HOPTS='-b ${HIBITS} -L'
  fi
fi
echo "heif-enc ${HOPTS} ${png} -o ${heif}"
time heif-enc ${HOPTS} "${png}" -o "${heif}" && rm -f "${png}"
