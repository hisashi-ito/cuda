#include <stdlib.h>
#include <time.h>

// ホスト側でベクトルの和を計算
void sumArrayOnHost(float *A, float *B, float *C, cont in N){
  for(int idx = 0; idx < N; idx++){
    C[idx] = A[idx] + B[idx];
  }
}

//データ初期化
void initialData(){
  
}
