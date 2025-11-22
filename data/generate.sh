#!/bin/bash
INPUT=$1
TIMES=$2
OUTPUT=data.txt

rm -f $OUTPUT
for i in $(seq 1 $TIMES); do
    cat $INPUT >> $OUTPUT
done

echo "Generated $OUTPUT with $TIMES repetitions of $INPUT"
