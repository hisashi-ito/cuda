//
// Name: spmv.h
//
// File Name:       spmv.h   (header file)
// Definition file: spmv.cpp (definition file)
//
// 概要: SpMv計算を実行するクラス
//       行列演算はEigen3を利用する
//
// 更新履歴:
//           2018.05.16 新規作成
//
#ifdef  _SPMV_
#define _SPMV_

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <fstream>
#include <typeinfo>
#include <iomanip>
#include <algorithm>
#include <Eigen/Sparse>
#include "util.h"

using namespace std;
using namespace Eigen;

class Spmv{
 public:
  // constructor
  Spmv(const string coo_file, const int iteration);
  // destrcutor
  ~Spmv(void);

  // 遷移行列の読み込み(text-COO形式)
  // COO形式の遷移行列はトリプレット(float)のvectorとして読み込む
  void load_matrix(const string file, vector< Triplet<float> > &tvec);

  // 実行関数(calc)
  // spmv計算をiteration回実行する
  void calc();

 private:
  int iteration;    // 冪情報の繰り返し回数
  int nnz;          // 行列(A)の非ゼロ要素の数
  int row_size = 0; // 行列(A)の行数 (c11のみ)
  int col_size = 0; // 行列(A)の列数 (c11のみ)
  Util *util;       // util オブジェクトのポインタ
  // CRS形式の遷移行列
  SparseMatrix<float> A;  
};
#endif /*_SPMV_*/
