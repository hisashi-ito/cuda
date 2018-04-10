#! /bin/sh
alpha=0.85
mat="../data/matrix.tsv"
vec="../data/vec.tsv"
output="./output.tsv"
iteration=5
cmd="./rwr"
main_cmd="${cmd} -i ${mat} -v ${vec} -o ${output} -a ${alpha} -t ${iteration}"
echo ${main_cmd}
eval ${main_cmd}
