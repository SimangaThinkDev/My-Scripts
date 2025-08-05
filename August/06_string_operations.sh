#!/bin/bash

myvar="Hey buddy, how are you??"

# Get the length
echo "Length is ${#myvar}"

# Print value in all Uppercase
echo "Uppercase ---- ${myvar^^}"

# Print value in all Lowercase
echo "Lowercase ---- ${myvar,,}"

# replacing values
echo "${myvar/buddy/bro}"

# slicing
echo "${myvar:2:3}"
