//
// 【main】
// 
//  概要: COO形式の行列データを読み込みCRS形式へ
//        変換したのちSpMv計算を実施する
//        SpMv計算はN回計算して計算にかかった時間の平均求める
//        本コマンドは Eigen3 ライブラリを利用する
//
//        OpenMP対応は初期ベクトルの本数を複数用意しておき
//        OpenMPは初期ベクトルの計算自体並列化する
//        一番外側のループやね...
//
//  usage: spmv -i <遷移行列> (COO形式)
//              -t <iteration回数>
//              -n <初期ベクトル本数>
//
//  更新履歴:
//           2018.05.16 新規作成
//           2018.05.17 OpenMP 対応
//
#include <stdio.h>
#include <unistd.h>
#include <iostream>
#include <stdlib.h>
#include <getopt.h>
#include <string>
#include <omp.h>
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
  string trans_mat;        // 遷移行列ファイル
  string iteration;        // spmv計算の繰り返し回数
  string num_vec;          // 初期ベクトルの本数
  Util *util = new Util();  // タイマ
  
  // 引数parse
  while((opt = getopt(argc, argv,"i:t:n:")) != -1){
    switch(opt){
    case 'i':
      trans_mat = optarg;
      break;
    case 't':
      iteration = optarg;
      break;
    case 'n':
      num_vec = optarg;
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

  // 遷移行列をメモリ上に展開する
  Spmv *spmv = new Spmv(trans_mat, atoi(iteration.c_str()));

#ifdef _BENCHMARK_
  cout << "*** 計測を開始します ***" << endl;
  double start_time = util->cpu_timer();
#endif /*_BENCHMARK_*/
  
  // 異なる初期ベクトルを計算する箇所でOpenMP並列化する
#pragma omp parallel for
  for(int n = 0; n < atoi(num_vec.c_str()); n++){
    spmv->calc();
  }
  
#ifdef _BENCHMARK_
  double elapsed_time = util->cpu_timer() - start_time;
  cout << "初期ベクトルの本数:" << num_vec << endl;
  cout << "1回あたりの繰り返し回数:" << iteration << endl;
  cout << "総処理時間[sec]:" << elapsed_time << endl;
  cout << "1回あたりの平均時間[msec]:" << ((elapsed_time/atof(iteration.c_str()))*1000.0)/atof(num_vec.c_str()) << endl;
  cout << "*** 計測が完了しました ***" << endl;
#endif /*_BENCHMARK_*/
  exit(0);
}
