//
// Name: diag.h
//
// File Name:       diag.h  (header file)
// Definition file: diag.cu (definition)
//
// 概要: 対角化を実行するクラス
//       体格鳳凰はPOWER MTHOD のみを扱う
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
  // coo_file:  行列ファイル名(COO格納方式)
  // iteration: 繰り返し回数
  // alpha:     G-parameter
  Diag(const string coo_file, int iteration, double alpha);
  
  // デストラクタ
  ~Driag(void);
  
  // 行列の読み込み処理
  // COO格納形式で読み込むので rows, colums, values の３つの変数に格納する
  // 各変数はホスト変数として読み込まれる
  void load_matrix(const string file,
		   thrust::host_vector<int> &rows,
		   thrust::host_vector<int> &columns,
		   thrust::host_vector<double> &values);
  // split 関数
  vector<string> split(const string &s, char delim);
  
 private:
  string coo_file; // COO形式の行列(A)ファイル　
  int iteration;   // べき乗法の繰り返し回数
  double alpha;    // アルファパラメータ(G-parameter)
  int nnz;         // 行列(A)の非ゼロ要素の数
  int row_size;    // 行列(A)の行数
  int col_size;    // 行列(A)の列数
  
  // [ホスト側]
  //  COO形式の行列(A)を保存するための配列
  thrust::host_vector<double> h_values;
  thrust::host_vector<int> h_rows;
  thrust::host_vector<int> h_cols;
};
/*_DIAG_*/
