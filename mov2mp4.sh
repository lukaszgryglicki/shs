#!/bin/sh
out="`echo "$1" | cut -d'.' -f1`.mp4"
ffmpeg -i "$1" -vcodec h264 -mbd 2 -preset slower -crf 19 -acodec aac -ac 1 -ar 22050 -f mp4 "$out"
