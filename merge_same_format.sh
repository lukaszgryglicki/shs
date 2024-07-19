#!/bin/bash
cd cropped
> list.txt
for f in $(ls crop_*.mp4)
do
  echo "file '$f'" >> list.txt
done
ffmpeg -y -safe 0 -f concat -i list.txt -c copy merged.mp4
rm list.txt
cd ..
echo 'Merged'
