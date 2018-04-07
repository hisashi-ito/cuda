#! /bin/sh
nvcc diag.cu util.cpp -Wno-deprecated-gpu-targets -D _DEBUG_ -lcusparse -run
