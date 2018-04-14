# Make file for rwr (Eigen版)
CC       = g++
CFLAGS   = -std=c++11
OPTIMIZE = -O3
INCLUDE  = ../eigen/lib/eigen3.3.4
OBJECT   = main.o rwr.o diag.o util.o
PROGRAM  = rwr

${PROGRAM} : ${OBJECT}
	${CC} -o $@ ${OBJECT} -I ${INCLUDE} ${OPTIMIZE} 
.cpp.o :
	${CC} -c $< ${CFLAGS} -I ${INCLUDE} ${OPTIMIZE}
clean:
	rm ${PROGRAM} ${OBJECT}
