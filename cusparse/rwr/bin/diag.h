//
// Name: diag
//
// File Name:       diag.h  (header file)
// Definition file: diag.cu (definition)
//
// 概要: 対角化を実行するクラス
//       現在は冪情報のみを扱う
//       (厳密にはさgoogle matrixを対角化する)
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
#include <typeinfo>
#include <iomanip>
#include <cuda_runtime.h>
#include <cusparse_v2.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/copy.h>

using namespace std;

class Diag{
 public:
  // コンストラクタ
  // coo_file(行列ファイル):  string
  // iteration(繰り返し回数): iteratio
  // alpha(G-parmeter):       double
  //
  Diag(const string coo_file, int iteration, double alpha);
  
  // デストラクタ
  ~Driag(void);
  
  // 行列の読み込み(COO形式)
  void load_matrix(const string file,
		   thrust::host_vector<int> &rows,
		   thrust::host_vector<int> &columns,
		   thrust::host_vector<double> &values);
  // split関数
  vector<string> split(const string &s, char delim);
  
 private:
  string coo_file; // COO形式の行列ファイル
  int iteration;   // 繰り返し回数
  double alpha;    // アルファパラメータ(google parameter)
  int nnz;         // 非ゼロ要素の数
  int row_size;    // number of rows of matrix
  int col_size;    // number of cols of matrix 
  
  // [ホスト側]
  //  COO 形式用のメモリを確保
  thrust::host_vector<double> h_values;
  thrust::host_vector<int> h_rows;
  thrust::host_vector<int> h_cols;
};
/*_DIAG_*/ 
