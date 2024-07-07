#!/bin/bash
for f in *.flac
do
  echo "start $f"
  flac2mp3.sh "$f"
  echo "done $f"
done
