//
// Name: util.h
//
// File Name:       util.h   (header file)
// Definition file: util.cpp (definition)
//
// 概要: ツール等のユーティリティクラス
//       c++で実装されていない汎用的な
//       高級関数を予め用意しておく
//
// 更新履歴: 
//          2018.04.07 新規作成
//
#ifndef _UTIL_
#define _UTIL_

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <typeinfo>
#include <iomanip>
#include <sstream>
#include <cstdlib>

using namespace std;

class Util{
 public:
  // コンストラクタ
  Util(void);
  
  // デストラクタ
  ~Util(void);
  
  // split 関数
  vector<string> split(const string &s, char delim);
  
  // join 関数
  string join(vector<double> &v);
};
#endif /*_UTIL_*/
