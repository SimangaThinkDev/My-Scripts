#!/bin/bash

echo "Please select from the below choices what to do"
echo "(a) Print the current time"
echo "(b) See the files in the current working directory"
echo "(c) See the current working directory"

read -p ">> " choice

case $choice in
	a) date;; # This ";;" tells the shell to break
	b) ls;;
	c) pwd;;
	*) echo "Not a valid input" # default case
esac

