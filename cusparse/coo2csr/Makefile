# Make file for coo2csr
coo2csr:coo2csr.cu
	nvcc -Wno-deprecated-gpu-targets -lcusparse -o coo2csr coo2csr.cu
clean:
	rm coo2csr
