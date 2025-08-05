#!/bin/bash

# Key-Value Arrays, formely known to me as Maps or dictionaries
# Explicity declare the Key-Value Array
declare -A myArray
myArray=( [name]=Smanga [city]=evaton [age]=24 )

# Accessing values in Key-Value ArrayList
echo "${myArray['name']}"

