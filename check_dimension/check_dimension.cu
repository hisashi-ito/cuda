#include <cuda_runtime.h>
#include <stdio.h>

__global__ void checkIndex(void){
  printf("threadIdx: (%d,%d,%d) blockIdx: (%d, %d, %d) blockDim: (%d, %d, %d) gridDim: (%d, %d, %d)\n",
	 threadIdx.x, threadIdx.y, threadIdx.z,
	 blockIdx.x, blockIdx.y, blockIdx.z,
	 blockDim.x, blockDim.y, blockDim.z,
	 gridDim.x, gridDim.y,gridDim.z
	 );
}

int main(int argc, char** argv){
  // データの要素の合計数
  int nElem = 6;

  // グリッドとブロック構造を定義
  //
  // thread < block < grid 
  //
  // dim3 はdim3宣言とよばれていて
  // dim3 grid(10,10)はgridの中に10x10のblockを起動する
  // dim3 block(8,8,8)はblock中に8x8x8のthreadを起動する
  
  dim3 block(3); // ブロック中に3 thread を起動する
  
  // 指定されたデータサイズとスレッド数からグリッド数の引数(ブロック数)を指定する
  // (6 + 3 - 1) /  3 =  2 
  dim3 grid((nElem + block.x - 1)/block.x);

  // グリッドサイズをホスト側から確認
  printf("grid.x %d grid.y %d grid.z %d\n", grid.x, grid.y, grid.z);
  printf("block.x %d block.y %d block.z %d\n", block.x, block.y, block.z);

  // グリッドサイズをデバイス側から確認
  checkIndex<<<grid, block>>>();

  // デイバイスをリセット(これを記述しないと動かない)
  cudaDeviceReset();
  return(0);
}
