#!/bin/bash
# Created by: Elias Mote and Ryan Moeller

choice=0
while [ $choice != 3 ]
do
	echo 'Please input the problem number (1 or 2) or 3 to quit.'
	read choice
	if [ $choice == 1 ]
	then
		python project_1_prob_1.py
	elif [ $choice == 2 ]
	then
		# TODO: Insert code to run project 1 problem 2
		echo 'Run project 1 problem 2'
	elif [ $choice == 3 ]
	then
		break
	else
		echo 'That choice is not available.'
	fi
done