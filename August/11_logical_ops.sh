#!/bin/bash

echo "Check if you are available to work"

read -p "What is your age?: " age

if [ $age -gt 18 ] && [ $age -lt 60 ]
then
	echo "You can work"
else
	echo "Sorry, you can't work"
fi

