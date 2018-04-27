//
// 【rwr】
// 
//  概要: Random Walk with Restart(RWR) の cuSPARSE版 実装
//        本コマンドは COO形式の遷移行列と初期ベクトルファイルを
//        読み込み初期ベクトルに対応した推薦結果を作成する
//        本コマンドは cuSPARSE ライブラリを利用する
//
//  usage: rwr -i <遷移行列> (COO形式)
//             -v <初期ベクトルファイル>
//             -a <rwr のalpha パラメータ> 
//             -t <iteration回数>
//             -o <出力>
//
//  更新履歴:
//           2018.04.02 新規作成
//
#include <stdio.h>
#include <unistd.h>
#include <iostream>
#include <stdlib.h>
#include <getopt.h>
#include <string>
#include <thrust/host_vector.h>
#include "diag.h"
#include "util.h"
#include "rwr.h"
using namespace std;

// @main
// メイン関数
// @breaf Random Walk with Restart(RWR) の cuSPARSE版 実装のメイン関数
// @param  argc, *argv[]
//
int main(int argc, char *argv[]){
  // 引数の処理
  int opt = 0;
  string trans_mat;  // 遷移行列ファイル
  string init_vec;   // 初期べベクトルファイル
  string alpha;      // alpha パラメータ ・・・ google matrix parameter
  string iteration;  // 対角化時の繰り返し回数
  string output;     // 出力ファイル
  Util *utile = new Util();
  
  // 引数parse
  while((opt = getopt(argc, argv,"i:v:o:a:t:")) != -1){
    switch(opt){
    case 'i':
      trans_mat = optarg;
      break;
    case 'v':
      init_vec = optarg;
      break;
    case 'a':
      alpha = optarg;
      break;
    case 't':
      iteration = optarg;
      break;
    case 'o':
      output = optarg;
      break;
    case ':':  // no value applied
    case '?':  // invalid option
      exit(1);
    }
  }
  
  // 引数不正の場合,usage を出して終了
  if(trans_mat.empty() || init_vec.empty() || alpha.empty() || iteration.empty() || output.empty()){
    cerr << "[error] usage: rwr -i <trans_mat> -v <init_vec> -a <alpha> -t <iteration> -o <output>" << endl;
    exit(-1);
  }
  Rwr *rwr = new Rwr(trans_mat, init_vec, atoi(iteration.c_str()), atof(alpha.c_str()), output);
  double start_time = utile->cpu_timer();
  rwr->calc();
  double elapsed_time = utile->cpu_timer() - start_time;
  cout << "処理時間:" << elapsed_time << endl;
  rwr->write();
  exit(0);
}
