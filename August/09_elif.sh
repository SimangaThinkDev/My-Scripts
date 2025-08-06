#!/bin/bash

read -p "What is your grade?: " grade

if [ $grade -gt 90 ]
then
	echo "You are excelling"
elif [ $grade -gt 70 ]
then
	echo "You're getting there"
elif [ $grade -gt 50 ]
then
	echo "pick up your socks"
else
	echo "get another school"
fi
