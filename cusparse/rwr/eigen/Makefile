# Make file for rwr (Eigen版)
CC=g++
INCLUDE=../eigen/lib/eigen3.3.4
OPT=-std=c++11
csrmv:
	${CC} -Wall -o rwr main.cpp rwr.cpp diag.cpp util.cpp -I ${INCLUDE} ${OPT}
clean:
	rm rwr
