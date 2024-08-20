#!/bin/bash
for f in $(cat repos.txt)
do
  echo $f
  if [ -d "$f" ]
  then
    (cd "$f" && git pull && cd ..) || exit 1
  else
    git clone "https://github.com/lukaszgryglicki/$f" || exit 2
  fi
done
