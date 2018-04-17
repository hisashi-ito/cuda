#! /bin/sh
alpha=0.85
mat="../data/big_matrix.tsv"
vec="../data/big_vec.tsv"
output="./output.tsv"
iteration=30
#batch=100
cmd="./rwr"

for batch in 5 10 20 30 40 50 60 70 80 90 100
do
    main_cmd="time ${cmd} -i ${mat} -v ${vec} -o ${output} -a ${alpha} -t ${iteration} -b ${batch}"
    echo ${main_cmd}
    eval ${main_cmd}
done
