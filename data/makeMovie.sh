#!/bin/bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SEQ='0'

while getopts s: OPTION
do
  case $OPTION in 
     s)
        SEQ=$OPTARG
	;;
     o)
	OUT=$OPTARG
	;;
  esac
done

OUT=video_$SEQ\_`date +%H%M`.mp4

cd $DIR/../

/usr/bin/ffmpeg -r 8 -i toonloop_$SEQ\__%03d.jpg $OUT
/bin/rm *.jpg


