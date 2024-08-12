#!/bin/bash
mkdir ./jpg 2>/dev/null
for f in *.HIF
do
  of="./jpg/${f/.HIF/.jpg}"
  echo "$f -> $of"
  convert "$f" -quality 92% "$of"
done
