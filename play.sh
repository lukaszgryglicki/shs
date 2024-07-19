#!/bin/sh
find ../ -type f -size +5M > ./list.pls
mpv -fs -shuffle -loop 0 -playlist list.pls

