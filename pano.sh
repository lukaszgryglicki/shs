#!/bin/bash
# https://wiki.panotools.org/index.php?title=Panorama_scripting_in_a_nutshell&oldid=15700
if [ -z "$FOV" ]
then
  export FOV=58
fi
if [ -z "$PRJ" ]
then
  export PRJ=project.pto
fi
if [ -z "$HPATH" ]
then
  export HPATH='/Applications/Hugin/tools_mac'
fi
if [ -z "$CMODEL" ]
then
  export CMODEL='/Applications/Hugin//Hugin.app/Contents/Resources/xrc/celeste.model'
fi
if [ -z "$OUT" ]
then
  export OUT=pano
fi
if [ -z "$CPUS" ]
then
  export CPUS=8
fi
if [ -z "$QUAL" ]
then
  export QUAL=92
fi

echo "STEP 1: pto_gen"
"$HPATH/pto_gen" -f $FOV -o "$PRJ" "$@"
echo "STEP 2: cpfind"
"$HPATH/cpfind" --ransaciter=5000 --ransacdist=100 -v --multirow -o "$PRJ" "$PRJ"
echo "STEP 3: celeste"
"$HPATH/celeste_standalone" -s 2000 -d "$CMODEL" -i "$PRJ" -o "$PRJ"
echo "STEP 4: linefind"
"$HPATH/linefind" -o "$PRJ" "$PRJ"
echo "STEP 5: autooptimizer"
"$HPATH/autooptimiser" -a -l -s -m -o "$PRJ" "$PRJ"
echo "STEP 6: pano_modify"
"$HPATH/pano_modify" -o "$PRJ" --center --straighten --canvas=AUTO --crop=AUTO "$PRJ"
echo "STEP 7: hugin_executor"
"$HPATH/hugin_executor" -t=$CPUS -s --prefix="$OUT" "$PRJ"
echo "STEP 8: convert"
convert "$OUT.tif" -quality $QUAL "$OUT.JPG"
if [ -z "$TIF" ]
then
  rm -f "$OUT.tif"
fi
if [ -z "$PTO" ]
then
  rm -f "$PRJ"
fi

# "$HPATH/ptoclean" -v --output "$PRJ" "$PRJ"
# "$HPATH/cpclean" -v -o "$PRJ" "$PRJ"
# "$HPATH/autooptimiser" -a -l -s -o "$PRJ" "$PRJ"
