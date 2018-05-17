#! /bin/sh
cmd="../src/SPMV"
input="../data/matrix.txt"
tol=100
num=100
for cpus in 8 7 6 5 4 3 2 1
do
    export OMP_NUM_THREADS=${cpus}
    main_cmd="${cmd} -i ${input} -t ${tol} -n ${num}"
    echo ${main_cmd}
    eval ${main_cmd}
done
