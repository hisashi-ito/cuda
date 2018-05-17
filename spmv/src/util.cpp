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
//          2018.04.17 CPUタイマ関数の追加
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

// @join
//  join関数
// @breaf ruby等のjoin関数と同等
// @param vector(double)
//
string Util::join(vector<double> &v){
  string s;
  for(unsigned int i = 0; i < v.size(); i++){
    ostringstream oss;
    oss << v[i];
    if(i != v.size() - 1){
      s += oss.str() + ',';
    }else{
      s += oss.str();
    }
  }
  return s;
}

// @cpu_timer
//  CPUタイマ関数
// @breaf CPUの計算時間を測定する関数
//        とあるコード部分の経過時間を測定する場合は
//        start_time   = cpu_timer()
//        ・・・なにかの処理・・・
//        elapsed_time = cpu_timer() - start_time;
double Util::cpu_timer(){
  struct timeval tp;
  // time.hで定義されている関数
  gettimeofday(&tp, NULL);
  // tv_sec で秒, tv_usec でマイクロ秒を算出して合計して算出する
  return ((double)tp.tv_sec + (double)tp.tv_usec * 1.0e-6);
}
