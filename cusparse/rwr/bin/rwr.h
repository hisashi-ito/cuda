//
// Name: rwr.h
//
// File Name:       rwr.h  (header file)
// Definition file: rwr.cu (definition)
//
// 概要: Random Walk with Restart (RWR)の計算を制御するクラス
//
// 更新履歴: 
//          2018.04.07 新規作成
//
#ifndef _RWR_
#define _RWR_

#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <typeinfo>
#include <iomanip>
#include <thrust/host_vector.h>
#include "diag.h"
#include "util.h"
using namespace std;

class Rwr{
 public:
  // コンストラクタ
  // coo_file:    行列ファイル名(COO格納方式)
  // vector_file: 推薦元データのベクトル
  // iteration:   繰り返し回数
  // alpha:       G-parameter
  // output:      出力ファイル名
  // 
  Rwr(string coo_file, string vec_file, int iteration, double alpha, string output);
  
  // デストラクタ
  ~Rwr(void);
  
  // 推薦元のベクトル読み込み
  void load_vecs(string file, vector< vector<double> > &vecs);
  
  // 実行関数
  void calc();
  
 private:
  // rwrのiteration 回数
  int iteration;
  // G-marix の係数
  double alpha;
  // 出力ファイル名
  string output;
  // 推薦元の初期ベクトル配列
  vector< vector<double> > vecs;
  // 出力データベクトル
  thrust::host_vector< thrust::host_vector<double> > results;
  //vector< vector<double> > results;
  // 対角化オブジェクト
  Diag *diag;
  // util オブジェクトへのポインタ
  Util *util;
};
#endif /*_RWR_*/
