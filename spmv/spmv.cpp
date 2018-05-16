//
// Name: spmv.cpp
//
// File Name:       spmv.cpp (definition)
// Definition file: spmv.h   (header)
//
// 概要: SpMv計算を実行するクラスの定義
//       行列演算はEigen3を利用する
//
// 更新履歴:
//          2018.04.13 新規作成
//
#include "svmv.h"

// @constructor
Spmv::Spmv(const string coo_file, const int iteration){
  this->util      = new Util();
  this->iteration = iteration;
  // 遷移行列の読み込み用ベクトルを用意
  vector< Triplet<float> > tvec;
  // COO形式行列を読み込む
  load_matrix(coo_file, tvec);
  
}
