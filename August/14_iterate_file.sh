#!/bin/bash

# store the path of the txt file
path="./text.txt"

for line in $( cat $path )
do
	echo "$line"
done

