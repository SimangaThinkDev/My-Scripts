#!/bin/bash

for i in 1 2 3 4 5
do
	echo "i is $i"
done

echo ""
echo "Loop with names"

for name in Peter John Caesar
do
	echo "Hello, $name"
done

echo ""
echo "Loop in a range inclusive"
for num in {1..10}
do
	echo "$num"
done

