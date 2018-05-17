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
#ifndef _SPMV_
#define _SPMV_

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <fstream>
#include <typeinfo>
#include <iomanip>
#include <stdlib.h>
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
  // COO 形式の遷移行列はトリプレット(float)のvectorとして読み込む
  void load_matrix(const string file, vector< Triplet<float> > &tvec);

  // 初期ベクトル作成
  VectorXf make_init_vec();
  
  // 実行関数(calc)
  // spmv 計算をiteration 回実行する
  void calc();

 private:
  int iteration;    // spmv 計算の計算回数
  int nnz;          // 行列(A)の非ゼロ要素の数
  int row_size = 0; // 行列(A)の行数 (c11のみ)
  int col_size = 0; // 行列(A)の列数 (c11のみ)
  Util *util;       // util オブジェクトのポインタ
  // CRS 形式の遷移行列
  SparseMatrix<float> A;  
};
#endif /*_SPMV_*/
