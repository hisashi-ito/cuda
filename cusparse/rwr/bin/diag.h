//
// Name: diag.h
//
// File Name:       diag.h  (header file)
// Definition file: diag.cu (definition)
//
// 概要: 対角化を実行するクラス
//       対角化法はPOWER MTHOD のみを扱う
//       (厳密にはgoogle matrixを対角化する)
//       
//       CUDA のポインタ管理には thrustを利用する
//
// 更新履歴: 
//          2018.04.03 新規作成
//
#ifndef _DIAG_
#define _DIAG_

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <fstream>
#include <typeinfo>
#include <iomanip>
#include <algorithm>
#include <cuda_runtime.h>
#include <cusparse_v2.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/device_ptr.h>
#include <thrust/inner_product.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/fill.h>
#include <thrust/copy.h>
#include "util.h"

using namespace std;

class Diag{
 public:
  // コンストラクタ
  // coo_file:  行列ファイル名(COO格納方式)
  // iteration: 繰り返し回数
  // alpha:     G-parameter
  Diag(const string coo_file, int iteration, double alpha);
  
  // デストラクタ
  ~Diag(void);
  
  // 行列の読み込み処理
  // COO格納形式で読み込むので rows, cols, vals の３つの変数に格納する
  // 各変数はホスト変数として読み込まれる
  void load_matrix(const string file,
		   thrust::host_vector<int> &rows,
		   thrust::host_vector<int> &cols,
		   thrust::host_vector<double> &vals);

  // 冪乗法
  // COO形式読み込まれた行列を冪乗法にて対角化する
  void power_method(thrust::host_vector<double> &h_x,
		    thrust::host_vector<double> &h_y);
  
  // ベクトルの正規化
  void normalize(thrust::device_vector<double> &v);
  
  // 定数の乗算
  // v = alpha * v
  void const_multiplies(thrust::device_vector<double> &v, double alpha);
  
 private:
  int iteration;   // 冪情報の繰り返し回数
  double alpha;    // アルファパラメータ(G-parameter)
  int nnz;         // 行列(A)の非ゼロ要素の数
  int row_size;    // 行列(A)の行数
  int col_size;    // 行列(A)の列数
  Util *util;      // util オブジェクトのポインタ
  
  // [ホスト側]
  //  COO形式の行列(A)を保存するための配列
  thrust::host_vector<int> h_rows;
  thrust::host_vector<int> h_cols;
  thrust::host_vector<double> h_vals;
  //  CSR形式の行列(A)を保存するための配列
  thrust::host_vector<int> d_csr_cols;
  thrust::host_vector<int> d_rows;
  thrust::host_vector<int> d_csr_rows;
  thrust::host_vector<double> d_csr_vals;
};
#endif /*_DIAG_*/
