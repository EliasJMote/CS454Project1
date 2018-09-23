# Created by: Elias Mote and Ryan Moeller

from sympy import *

# Get input from the user
print("Problem 1:")
print("Please input n")
n = int(raw_input("--> "))

# Delta function
delta = [
			# Start state
			[1,2,3],    # empty

			# Single letter states (a - c)
			[4,5,6],    # a
			[7,8,9],    # b
			[10,11,12], # c

			# Double letter states (aa - cc)
			[37,13,14], # aa
			[15,16,17], # ab
			[18,19,20], # ac
			[21,22,23], # ba
			[24,37,25], # bb
			[26,27,28], # bc
			[29,30,31], # ca
			[32,33,34], # cb
			[35,36,37], # cc

			# Triple letter states (aab - ccb)
			# axy states
			[37,37,17], # aab
			[37,19,37], # aac
			[37,37,23], # aba
			[37,37,25], # abb
			[26,27,28], # abc
			[37,30,37], # aca
			[32,33,34], # acb
			[37,36,37], # acc

			# bxy states
			[37,37,14], # baa
			[37,37,17], # bab
			[18,19,20], # bac
			[37,37,23], # bba
			[26,37,37], # bbc
			[29,30,31], # bca
			[32,37,37], # bcb
			[35,37,37], # bcc

			# cxy states
			[37,13,37], # caa
			[15,16,17], # cab
			[37,19,37], # cac
			[21,22,23], # cba
			[24,37,37], # cbb
			[26,37,37], # cbc
			[37,30,37], # cca
			[32,37,37], # ccb

			# Failure state
			[37,37,37], # fail state
		]

# DFA
# Starting state 0: ""
# States 1-3 are "a" - "c"
# States 4-12 are "aa" - "cc"
# States 13-36 are "aab" - "ccb"
# State 37 is a fail state

# m is how many states we have
m = 38

# Transition matrix A
A = [[0 for x in range(m)] for y in range(m)]

# If there is a transition in the delta function, increment the value in the matrix
for j in range(38):
	for k in range(3):
		A[j][delta[j][k]] += 1
A = Matrix(A)

# Create matrix u
u = [[1]]
for i in range(37):
	u[0].append(0)
u = Matrix(u)

# Create matrix v
v = [1 for x in range(m)]
for i in range(13):
	v[i] = 0
v[37] = 0
v = Matrix(v)

# Print our result
print((u*(A**n)*v)[0])