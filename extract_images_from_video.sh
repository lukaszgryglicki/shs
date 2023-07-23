if [ -z "$1" ]
then
  echo "$0: you need to specify an input file"
  exit 1
fi
ffmpeg -accurate_seek -ss 30.0 -i "$1" -t 5.0 frame%05d.png
