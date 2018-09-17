# Created by: Elias Mote and Ryan Moeller

option = 0
while(option != "3"):
	print("Choose an option:")
	print("[1]: Problem 1")
	print("[2]: Problem 2")
	print("[3]: Quit")
	option = raw_input("--> ")

	# Problem 1
	if(option == "1"):
		print("Problem 1:")
		print("Please input n")
		n = raw_input("--> ")

	# Problem 2
	elif(option == "2"):
		print("Problem 2:")
		# TODO: Place hook here