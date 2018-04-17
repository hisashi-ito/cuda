# Make file for rwr (CUDA版)
CC       = nvcc
#GFLAGS   = #-arch=sm_62 -gencode=arch=compute_62,code=sm_62
GFLAGS   = -arch=sm_50 -gencode=arch=compute_50,code=sm_50
LINK     = -lcusparse
CPP      = -D _BENCHMARK_
OPTIMIZE = -O3
WALL     = --compiler-options -Wall
OBJECT   = main.o rwr.o diag.o util.o
PROGRAM  = rwr
.SUFFIXES: .o .cpp .cu

${PROGRAM}:${OBJECT}
	${CC} -o $@ ${OBJECT} ${WALL} ${GFLAGS} ${OPTIMIZE} ${LINK} ${CPP}
.cu.o:
	${CC} -c $< ${WALL} ${GFLAGS} ${OPTIMIZE} ${CPP}
.cpp.o:
	${CC} -c $< ${WALL} ${GFLAGS} ${OPTIMIZE} ${CPP}
clean:
	rm ${PROGRAM} ${OBJECT}
