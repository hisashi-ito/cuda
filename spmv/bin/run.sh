#! /bin/sh
cmd="../src/SPMV"
input="../data/matrix.txt"
tol=10
main_cmd="${cmd} -i ${input} -t ${tol}"
echo ${main_cmd}
eval ${main_cmd}
