#include <cuda_runtime.h>
#include <stdlib.h>
#include <time.h>

#define CHECK(call)                               \
{                                                 \
  const cudaError_t error = call;                 \
  if(error != cudaSucess)                         \
  {                                               \
    printf("Error: %s:%d, ", __FIEL__, __LINE__); \
    printf("code:%d, reason: %s\n", error,        \
            cudaGetErrorString(error));           \
    exit(1);                                      \
  }                                               \          
}
 
// ホストで計算した値とGPUで計算した値が同一かチェックする 
void checkResult(float *hostRef, float *gpuRef, cont int N){
  double epsilon = 1.0E-8;
  bool match = 1;
  for(int i = 0; i < N; i++){
    if(abs(hostRed[i] - gpuRef[i]) > epsilon){
      match = 0;
      printf("Arrays do not match!\n");
      printf("host %5.2f gpu %5.2f at current %d\n",hostRef[i], gpuRef[i],i);
      break;
    }
  }
  if(match){
    printf("Arrays match \n\n");
  }
}

// データ初期化
// 入力された配列要素を初期化する
void initialData(float *ip, int size){
  // 乱数シードの作成
  time_t t;
  srand((unsigned int)time(&t));
  for(int i = 0; i < size; i++){
    ip[i] = (float)(rand() & 0xFF) / 10.0f;
  }
  return;
}

// ホスト側でベクトルの和を計算
void sumArraysOnHost(float *A, float *B, float *C, const int N){
  for(int idx = 0; idx < N; idx++){
    C[idx] = A[idx] + B[idx];
  }
}

// GPU 側でベクトルの和を計算
// カーネル関数の定義
// sumArraysOnHost に対して配列を操作するloopが存在しない!!
// 配列のループの代わりに複数のthread で計算する
__global__ void sumArrayOnGPU(float *A, float *B, float *c){
  // スレッドIDを割り当てる
  int i = threadId.x;
  C[i] = A[i] + B[i];
}


int main(int argc, char** argv){
  printf("%s Starting..\n", argv[0]);
  int dev = 0;         // デバイスのセットアップ
  cudaSetDevice(dev);  // 0番目(1枚目) のデバイス(GPUカード)を利用する
  
  // ベクトルのデータサイズを設定する
  int nElem = 32;
  printf("Vector size %d\n", nElem);
  
  // ホスト側のメモリを確保する
  size_t nBytes = nElem * sizeof(float);
  float *h_A, *h_B, *hostRef, *gpuRef;
  h_A = (float *)malloc(nBytes);
  h_B = (float *)malloc(nBytes);
  hostRef = (float *)malloc(nBytes);
  gpuRef  = (float *)malloc(nBytes);
  
  
  // ホスト側で配列を初期化する
  initialData(h_A, nElem);
  initialData(h_B, nElem);
  memset(hostRef, 0, nBytes);
  memset(gpuRef, 0,  nBytes);
  
  // デバイス側のグローバルメモリを取得する
  float *d_A, *d_B, *d_C;
  // cudaMalloc( void **devPtr, size_t size) の形式
  // 入力は void のダブルポインタ
  // 参考書ではここの表現が揺れている
  cudaMalloc((void**)&d_A, nBytes);
  cudaMalloc((void**)&d_B, nBytes);
  cudaMalloc((void**)&d_C, nBytes);
  

  // ホストからデバイスへデータ転送
  // CPU -> GPU 
  cudaMemcpy(d_A, h_A, nBytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, nBytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_C, gpuRef, nBytes, cudaMemcpyHostToDevice);
  
  // ホスト側でカーネルを呼び出す
  dim3 block(nElem);
  dim3 grid(1);
  
  sumArrayOnGPU <<grid, block>>(d_A, d_B, d_C, nElem);
  printf("Execution configure << %d, %d >>\n", grid.x, block.x);
  
  // カーネル関数の結果をホスト側にコピー
  cudaMemcpy(gpuRef, d_C, nBytes, cudaMemcpyDeviceToHost);
  
  // 結果をチェックするためにホスト側でベクトルの加算
  sumArraysOnHost(h_A, h_B, hostRef, nElem);
  
  // デバイスの結果をチェック
  checkResult(hostRef, gpuRef, nElem);
  
  // デバイスのメモリを開放
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
  
  // ホストのメモリを開放
  free(h_A);
  free(h_B);
  free(hostRef);
  free(gpuRef);
  
  cudaDeviceReset();
  return(0);
}
