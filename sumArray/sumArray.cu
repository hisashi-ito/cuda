#include <stdlib.h>
#include <time.h>

// ホスト側でベクトルの和を計算
void sumArrayOnHost(float *A, float *B, float *C, cont in N){
  for(int idx = 0; idx < N; idx++){
    C[idx] = A[idx] + B[idx];
  }
}

//データ初期化
void initialData(float *ip, int size){
  // 乱数シードの作成
  time_t t;
  srand((unsigned int)time(&t));
  for(int i = 0; i < size; i++){
    ip[i] = (float)(rand() & 0xFF) / 10.0f;
  }
  return;
}

int main(int argc, char** argv){
  int nElem = 1024;

  //  工事中...
  
}
