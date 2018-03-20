#include <stdio.h>

// カーネル関数
__global__ void helloFromGPU(){
  if(threadIdx.x == 5){
    printf("Hello World form GPU! thread %d\n",threadIdx.x);
  }
}

int main(int argc, char **argv){
  printf("Hello World from CPU!\n");
  // カーネル関数の呼び出し
  helloFromGPU<<<1, 10>>>();
  cudaDeviceReset();
  return 0;
}
