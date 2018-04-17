# Make file for rwr (CUDA版)
CC       = nvcc
GFLAGS   = #-arch=sm_62 -gencode=arch=compute_62,code=sm_62
LINK     = -lcusparse
OPTIMIZE = -O3
WALL     = --compiler-options -Wall
OBJECT   = main.o rwr.o diag.o util.o
PROGRAM  = rwr
.SUFFIXES: .o .cpp .cu

${PROGRAM}:${OBJECT}
	${CC} -o $@ ${OBJECT} ${WALL} ${GFLAGS} ${OPTIMIZE} ${LINK}
.cu.o:
	${CC} -c $< ${WALL} ${GFLAGS} ${OPTIMIZE}
.cpp.o:
	${CC} -c $< ${WALL} ${GFLAGS} ${OPTIMIZE}
clean:
	rm ${PROGRAM} ${OBJECT}
