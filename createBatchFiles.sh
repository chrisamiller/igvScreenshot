#!/bin/bash

for i in *.xml;do
    base=$(basename $i .xml)
    mkdir ${base}_snaps;

    a=$base.igv;
    echo "load $(pwd -P)/$i">$a;
    echo "snapshotDirectory $(pwd -P)/${base}_snaps">>$a;
    echo "maxPanelHeight 750" >>$a

    awk '{print "goto "$1":"$2"-"$3"\nsnapshot "$1"-"$2"-"$3".png"}' $base.bed >>$a;
    echo "exit" >>$a
done
echo "Launch IGV, then use 'Tools > Run Batch Script' to generate images"
