# Make file for rwr (CUDA版)
CC=nvcc
OPT=-Wno-deprecated-gpu-targets -lcusparse
csrmv:
	${CC} --compiler-options -Wall -o rwr main.cu rwr.cu diag.cu util.cpp ${OPT}
clean:
	rm rwr
