#!/bin/bash

welcomeNote() {
	# Access the variable by position
	echo "Hello, $1"
}

read -p "What is your name?: " name

welcomeNote $name

