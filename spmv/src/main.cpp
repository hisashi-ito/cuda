//
// 【main】
// 
//  概要: COO形式の行列データを読み込みCRS形式へ
//        変換したのちSpMv計算を実施する
//        SpMv計算はN回計算して計算にかかった時間の平均求める
//        本コマンドは Eigen3 ライブラリを利用する
//
//  usage: spmv -i <遷移行列> (COO形式)
//              -t <iteration回数>
//
//  更新履歴:
//           2018.05.16 新規作成
//
#include <stdio.h>
#include <unistd.h>
#include <iostream>
#include <stdlib.h>
#include <getopt.h>
#include <string>
#include "spmv.h"
#include "util.h"
using namespace std;

// @main
// メイン関数
// @breaf spmv の Eigen3版 実装のメイン関数
// @param argc, *argv[]
//
int main(int argc, char *argv[]){
  int opt = 0;
  string trans_mat;  // 遷移行列ファイル
  string iteration;  // spmv計算の繰り返し回数
  // 引数parse
  while((opt = getopt(argc, argv,"i:t:")) != -1){
    switch(opt){
    case 'i':
      trans_mat = optarg;
      break;
    case 't':
      iteration = optarg;
      break;
    case ':':  // no value applied
    case '?':  // invalid option
      exit(1);
    }
  }
  // 引数不正の場合,usage を出して終了
  if(trans_mat.empty() || iteration.empty()){
    cerr << "[error] usage: spmv -i <trans_mat> -t <iteration>" << endl;
    exit(-1);
  }
  Spmv *spmv = new Spmv(trans_mat, atoi(iteration.c_str()));
  spmv->calc();
  exit(0);
}
