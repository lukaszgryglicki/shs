#!/bin/bash
find . -type f -size +4M  > list.pls
mpv -shuffle -fs -playlist list.pls
