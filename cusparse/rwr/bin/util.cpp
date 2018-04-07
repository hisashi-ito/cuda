//
// Name: util
//
// File Name:   util.cpp (definition file)
// Header file: util.h   (header file)
//
// 概要: ツール等のユーティリティクラス
//       c++で実装されていない汎用的な
//       高級関数を予め用意しておく
//
// 更新履歴: 
//          2018.04.07 新規作成
//
#include "util.h"

// @constructor
Util::Util(void){}

// @destructor
Util::~Util(void){}

// @split
//  文字列分割関数
// @breaf 指定のデリミネタを利用してstringの文字列を分割する
//        分割された文字列は vector<string> 文字列に格納される
// @param 文字列(string)
// @param 分割デリミネタ(char)
// @return 分割された文字列が vector<string>で返却される
//
vector<string> Util::split(const string &s, char delim){
  vector<string> elems;
  stringstream ss(s);
  string item;
  while (getline(ss, item, delim)) {
    if (!item.empty()){
      elems.push_back(item);
    }
  }
  return elems;
}
