//
// Name: diag.h
//
// File Name:       diag.h   (header file)
// Definition file: diag.cpp (definition)
//
// 概要: 対角化を実行するクラス
//       対角化法はPOWER MTHOD のみを扱う
//       (厳密にはgoogle matrixを対角化する)
//       行列演算はEigen3を利用する
//
// 更新履歴: 
//          2018.04.13 新規作成
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
#include <Eigen/Sparse>
#include "util.h"

using namespace std;
using namespace Eigen;

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
  // COO格納形式のベクトルを読み,Sparse行列へ変換する
  void load_matrix(const string file, vector< Triplet<double> > &tvec);
  
  // 冪乗法
  // COO形式読み込まれた行列を冪乗法にて対角化する
  void power_method(VectorXd &x, VectorXd &y);
  
 private:
  int iteration;    // 冪情報の繰り返し回数
  double alpha;     // アルファパラメータ(G-parameter)
  int nnz;          // 行列(A)の非ゼロ要素の数
  int row_size = 0; // 行列(A)の行数 (c11のみ)
  int col_size = 0; // 行列(A)の列数 (c11のみ)
  Util *util;       // util オブジェクトのポインタ
  // 遷移行列
  SparseMatrix<double> A;
};
#endif /*_DIAG_*/
