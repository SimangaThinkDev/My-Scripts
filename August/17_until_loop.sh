#!/bin/bash

a=10

# do something until the condition is true
until [ $a -eq 1 ]
do
	echo $a
	((a--))
done

