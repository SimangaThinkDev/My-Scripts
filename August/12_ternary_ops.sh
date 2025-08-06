#!/bin/bash

read -p "Enter your age " age

# SYNTAX
# [ condition ] && 'executes true' || 'executes false'

[ $age -ge 18 ] && echo "You are an adult" || echo "You are a minor"


