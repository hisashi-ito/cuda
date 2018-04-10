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
#include <map>
#include <cstdlib>
#include <typeinfo>
#include <iomanip>
#include <cuda_runtime.h>
#include <cusparse_v2.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/copy.h>
#incldue "diag.h"
using namespace std;

class Rwr{
 public:
  // コンストラクタ
  // coo_file:    行列ファイル名(COO格納方式)
  // vector_file: 推薦元データのベクトル
  // iteration: 繰り返し回数
  // alpha:     G-parameter
  // 
  Rwr(const string coo_file, const string vec_file,
      int iteration, double alpha);
  
  // デストラクタ
  ~RWR(void);
  
  // split 関数
  vector<string> split(const string &s, char delim);
  
  // 推薦元のベクトル読み込み
  void load_vecs(string file, vector< vector<double> > &vecs);
  
 private:
  int iteration;                 // rwrのiteration 回数
  double alpha;                  // G-marix の係数
  vector< vector<double> > vecs; // 推薦元の初期ベクトル配列
};
#endif /*_RER_*/
