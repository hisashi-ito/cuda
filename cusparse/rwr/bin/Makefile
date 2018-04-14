# Make file for rwr (CUDA版)
CC=nvcc
# SM62 or SM_62, compute_62 – Drive-PX2, Tegra (Jetson) TX2, Denver-based GPU
OPT=-arch=sm_62 -gencode=arch=compute_62,code=sm_62 -lcusparse
csrmv:
	${CC} --compiler-options -Wall -o rwr main.cu rwr.cu diag.cu util.cpp ${OPT}
clean:
	rm rwr
