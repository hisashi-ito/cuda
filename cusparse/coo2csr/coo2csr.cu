//
// 【coo2csr】
//
//  概要: cuSPARSE 行列変換サンプル
//        coo保存形式からcsr形式への変換する
//
#include <cuda_runtime.h>
#include <iostream>
#include <cusparse_v2.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/copy.h>
#include <vector>
using namespace std;

int main(){

  // Matrix
  // ^^^^^^
  // 3 0 0
  // 6 0 0
  // 0 2 1

  // COO 形式
  thrust::host_vector<double> h_values;
  thrust::host_vector<int> h_rows;
  thrust::host_vector<int> h_cols;
  
  // non-zero 成分を保存
  h_values.push_back(3.0);
  h_values.push_back(6.0);
  h_values.push_back(2.0);
  h_values.push_back(1.0);
  // 縦方向
  h_cols.push_back(0);
  h_cols.push_back(0);
  h_cols.push_back(1);
  h_cols.push_back(2);
  // 横方向
  h_rows.push_back(0);
  h_rows.push_back(1);
  h_rows.push_back(2);
  h_rows.push_back(2);
  
  // [デバイス側]
  // cuSPARSE のハンドルを作成
  cusparseHandle_t handle;
  cusparseCreate(&handle);

  // non-zero 要素数
  int nnz = h_values.size();
  // 変換前の行列の行数(rows)
  int rsize = max_element(h_rows.begin(), h_rows.end());
  
  // デバイス側でCOO形式のデバイスメモリを取得
  // ただし、CSR形式への変換はh_values, h_cols は変更必要ない
  // h_rows だけが変更がなされる
  thrust::device_vector<double> d_values = h_values;
  thrust::device_vector<int> d_cols = h_cols;
  thrust::device_vector<int> d_rows = h_rows;
  thrust::device_vector<int> d_csr_rows(4);
  
  // 行列のディスクリプタを記述
  cusparseMatDescr_t matDescr;
  cusparseCreateMatDescr(&matDescr);
  cusparseSetMatType(matDescr, CUSPARSE_MATRIX_TYPE_GENERAL);
  cusparseSetMatIndexBase(matDescr, CUSPARSE_INDEX_BASE_ZERO);

  // COO -> CSR 形式へ変換(rowsだけ)
  cusparseXcoo2csr(handle,thrust::raw_pointer_cast(&d_rows[0]),nnz,rsize,
		   thrust::raw_pointer_cast(&d_csr_rows[0]),CUSPARSE_INDEX_BASE_ZERO);
  
  // 計算結果を確認
  for(int i =0; i< d_csr_rows.size(); i++){
    cout << d_csr_rows[i] << endl;
  }
  exit(1);
}
