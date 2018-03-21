#include <stdlib.h>
#include <time.h>

// ホスト側でベクトルの和を計算
void sumArraysOnHost(float *A, float *B, float *C, const int N){
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
  size_t nByte = nElem * sizeof(float);
  // ホスト側の変数にはプレフィックス "h_" を付与する 
  float *h_A, *h_B, *h_C;
  h_A = (float *)malloc(nByte);
  h_B = (float *)malloc(nByte);
  h_C = (float *)malloc(nByte);
  // 配列の要素を初期化
  initialData(h_A, nElem);
  initialData(h_B, nElem);

  // ホストで配列の和を計算
  sumArraysOnHost(h_A, h_B, h_C, nElem);

  // メモリを開放
  free(h_A);
  free(h_B);
  free(h_C);
  return(0);
}
