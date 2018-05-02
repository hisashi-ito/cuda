#! /bin/sh
alpha=0.85
mat="../data/huge_matrix.txt"
vec="../data/huge_vec.txt"
output="./output.tsv"
iteration=30
cmd="./rwr"
main_cmd="${cmd} -i ${mat} -v ${vec} -o ${output} -a ${alpha} -t ${iteration}"
echo ${main_cmd}
eval ${main_cmd}
