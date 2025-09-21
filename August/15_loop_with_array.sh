#!/bin/bash

#Array
myArray=( John Frank Innocent Brennan )

for name in ${myArray[*]}
do
	echo "Hello, $name"
done

