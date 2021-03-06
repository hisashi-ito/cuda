//
// 【csrmv】
//
//  概要: cusparse (MV)を利用するためのサンプルコード
//        利用する関数は　cusparseDcsrmv であり
//        ここでDはdouble, mvはmaxtrix * vector である。
//
#include<cuda_runtime.h>
#include<iostream>
#include<cusparse_v2.h>
#include<thrust/device_vector.h>

const int N = 1024;

int main(int argc, char** argv){
  // CSR形式疎行列を用意する
  double elements[N*3];
  int columnIndeces[N*3];
  int rowOffsets[N+1];
  int nonZeroCount = 0; // 非行列要素数
  rowOffsets[0]    = 0; // rowのオフセットの最初の要素は0

  // 行列の初期化(CSR形式)
  for(int i = 0; i < N; i++){
    elements[nonZeroCount] = 2;
    columnIndeces[nonZeroCount] = i;
    nonZeroCount++;
    if(i > 0){
      elements[nonZeroCount] = 1;
      columnIndeces[nonZeroCount] = i - 1;
      nonZeroCount++;
    }
    if(i < N-1){
      elements[nonZeroCount] = 1;
      columnIndeces[nonZeroCount] = i + 1;
      nonZeroCount++;
    }
    rowOffsets[i+1] = nonZeroCount;
  }

  // ベクトルを用意
  double vector[N];
  for(int i = 0; i < N; i++){
    vector[i] = i * 0.1;
  }
  // 返却用のホストベクトルを用意
  double result[N];

  // デバイス側の配列を用意
  thrust::device_vector<double> elementsDevice(N*3);
  thrust::device_vector<int>    columnIndecesDevice(N*3);
  thrust::device_vector<int>    rowOffsetsDevice(N+1);
  thrust::device_vector<double> vectorDevice(N);
  thrust::device_vector<double> resultDevice(N);
  
  // ホストベクトルをデバイスに転送
  thrust::copy_n(elements,      N*3, elementsDevice.begin());
  thrust::copy_n(columnIndeces, N*3, columnIndecesDevice.begin());
  thrust::copy_n(rowOffsets,    N+1, rowOffsetsDevice.begin());
  thrust::copy_n(vector, N, vectorDevice.begin());
    
  cusparseHandle_t handle;
  cusparseCreate(&handle);
  cusparseMatDescr_t matDescr;
  cusparseCreateMatDescr(&matDescr);
  cusparseSetMatType(matDescr, CUSPARSE_MATRIX_TYPE_GENERAL);
  cusparseSetMatIndexBase(matDescr, CUSPARSE_INDEX_BASE_ZERO);
  
  double* elementsPtr   = thrust::raw_pointer_cast(&(elementsDevice[0]));
  int* columnIndecesPtr = thrust::raw_pointer_cast(&(columnIndecesDevice[0]));
  int* rowOffsetsPtr    = thrust::raw_pointer_cast(&(rowOffsetsDevice[0]));
  double* vectorPtr     = thrust::raw_pointer_cast(&(vectorDevice[0]));
  double* resultPtr     = thrust::raw_pointer_cast(&(resultDevice[0]));
  double alpha = 1.0;
  double beta  = 0.0;
  cusparseDcsrmv(handle,CUSPARSE_OPERATION_NON_TRANSPOSE,N,N,nonZeroCount,
		 &alpha,matDescr,elementsPtr,rowOffsetsPtr,columnIndecesPtr,
		 vectorPtr,&beta,resultPtr);
  thrust::copy_n(resultDevice.begin(), N, result);
  for(int i = 0; i < N; i++){
    std::cout << result[i] << std::endl;
  }
  return 0;
}
