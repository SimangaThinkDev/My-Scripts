#!/bin/bash

myArray=(1 2 "Smanga" "Dev" 0.1 Think)

# Retrieve values
echo "${myArray[0]}"
echo "${myArray[4]}"

# Printing all values of an array
echo "All the values in my array ${myArray[*]}"

# Getting the length of the Array
echo "The number of values in my array ${#myArray[*]}"

# Printing a range of values in myArray
echo "Ranging my array from 1-3 ${myArray[*]:1:3}"

# Appending values to an array
myArray+=("One More" "Maybe Two")
echo "Updated array ${myArray[*]}"

# Update values at index
myArray[2]="Simangaliso"
echo "Updated array ${myArray[*]}"

# Delete values in an Array
unset myArray[2]
echo "Updated array ${myArray[*]}"

# Key-Value Arrays, formely known to me as Maps or dictionaries


