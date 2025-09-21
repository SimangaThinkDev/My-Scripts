#!/bin/bash

# SYNTAX
# function myfun {
#	do something
# }

user=$HOSTNAME

function greetUser {
	echo "-----------------------------------------------------------------"
	echo "----------------------- Hello, $user ------------------------"
	echo "-----------------------------------------------------------------"
}

# We can also define a function like this
sayBye() {
	echo "-----------------------------------------------------------------"
	echo "----------------------- Bye, $user --------------------------"
	echo "-----------------------------------------------------------------"
}

greetUser
sleep 5s
sayBye
sleep 3s

