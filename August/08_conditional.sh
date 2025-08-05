#!/bin/bash

read -p "What is your score " score

if [ $score -ge 90 ]
then
	echo "You are Excelling"
elif [ $score -ge 70 ]
then
	echo "Very good"
elif [ $score -ge 50 ]
then
	echo "Well done, but we can do more"
else
	echo "Come on bruv"
fi

