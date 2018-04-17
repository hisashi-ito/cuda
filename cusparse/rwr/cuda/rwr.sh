#! /bin/sh
alpha=0.85
mat="../data/big_matrix.tsv"
vec="../data/big_vec.tsv"
output="./output.tsv"
iteration=30
batch=100
cmd="./rwr"
main_cmd="${cmd} -i ${mat} -v ${vec} -o ${output} -a ${alpha} -t ${iteration} -b ${batch}"
echo ${main_cmd}
eval ${main_cmd}
