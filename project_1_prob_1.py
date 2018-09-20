# Created by: Elias Mote and Ryan Moeller

print("Problem 1:")
print("Please input n")
n = raw_input("--> ")

# Delta function
delta = [[1,4,7,10,37,15,18,21,24,26,29,32,35,15,18,21,24,26,29,32,35,37,15,18,21,26,29,32,35,37,15,18,21,24,26,29,32,37],
		 [2,5,8,11,13,16,19,22,37,27,30,33,36,16,19,22,37,27,30,33,36,13,16,19,22,27,30,33,36,13,16,19,22,37,27,30,33,37],
		 [3,6,9,12,14,17,20,23,25,28,31,34,37,17,20,23,25,28,31,34,37,14,17,20,23,28,31,34,37,14,17,20,23,25,28,31,34,37]]

# DFA
# Starting state 0: ""
# States 1-3 are "a" - "c"
# States 4-12 are "aa" - "cc"
# States 13-36 are "aab" - "ccb"
# State 37 is a fail state

# m is how many states we have
m = 38

# The 38 x 38 matrix
matrix = [[0 for x in range(m)] for y in range(m)]

# If there is a transition in the delta function, increment the value in the matrix
for j in range(38):
	for k in range(3):
		matrix[j][delta[j][k]] += 1