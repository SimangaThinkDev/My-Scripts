#!/bin/bash

# Defining Variables
NAME="Simangaliso"
SURNAME="Phakwe"
AGE=12

echo "My name is $NAME and age is $AGE"

# Store outputs of commands
PC_Hostname=$(hostname)

echo "Stored hostname is $PC_Hostname"

# Store the location of the current working directory.
PWD=$(pwd)
echo "We are in path $PWD"

# Define constants
readonly gender="Male"

# If we try to change the value
gender="Female" # For some reason

# We can see in output that it did not change
echo "Final gender value $gender"
