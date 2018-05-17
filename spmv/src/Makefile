# Make file for Spmv (Eigen3実装)
CC       = g++
CFLAGS   = -std=c++11
OPTIMIZE = -O3 -fopenmp
INCLUDE  = ../../eigen/lib/eigen3.3.4
CPP      = -D _BENCHMARK_
OBJECT   = main.o spmv.o util.o
PROGRAM  = SPMV

${PROGRAM} : ${OBJECT}
	${CC} -o $@ ${OBJECT} -I ${INCLUDE} ${OPTIMIZE} ${CPP}
.cpp.o :
	${CC} -c $< ${CFLAGS} -I ${INCLUDE} ${OPTIMIZE} ${CPP}
clean:
	rm ${PROGRAM} ${OBJECT}
