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
//             -o <出力>
//  更新履歴:
//           2018.04.02 新規作成
//
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <sstream>
#include <cstdlib>
#include <typeinfo>
#include <iomanip>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <cuda_runtime.h>
#include <cusparse_v2.h>

using namespace std;

// @split
//  文字列分割関数
// @breaf 指定のデリミネタを利用してstringの文字列を分割する
//        分割された文字列は vector<string> 文字列に格納される
// @param 文字列(string)
// @param 分割デリミネタ(char)
// @return 分割された文字列が vector<string>で返却される
//
vector<string> split(const string &s, char delim){
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

// @load_maxtrix
// @breaf  COO形式の遷移行列を読み込み以下の配列要素(vector)を返却
//         rows, columns, values の３つ。
// @params 遷移行列のファイル名(string)
//         行配列(rows)
//         列配列(columns)
//         行列要素の値(values)
// @return void
//
void load_matrix(string file,
		 vector<int> &rows,
                 vector<int> &columns,
                 vector<double> &values){
  string buff;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 遷移行列のファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  // 遷移行列の読み込み
  // フォーマット) row<TAB>column<TAB>value
  while(getline(ifs, buff)){
    vector<string> elems = split(buff, '\t');
    int row    = atoi(elems[0].c_str());
    int col    = atoi(elems[1].c_str());
    double val = (double)atof(elems[2].c_str());
    // vector へpushする
    rows.push_back(row);
    columns.push_back(col);
    values.push_back(val);
  }
}

// @load_vec
// @breaf 推薦元となる初期ベクトルを読み込む
// @params ファイル名<string>
//         初期ベクトル(vec)
// @return void
//   
void load_vecs(string file, vector< vector<double> > &vecs){
  string buff;
  vector<double> tmp;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 初期ベクトルファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  
  // 初期ベクトルファイルの読み込み
  // フォーマット) 数値1<SP>数値2...
  while(getline(ifs, buff)){
    vector<string> elems = split(buff, ' ');
    for(int i = 0; i < elems.size(); i++){
      tmp.push_back((double)atof(elems[i].c_str()));
    }
    vecs.push_back(tmp);
    tmp.clear();
  }
}

// @main
// メイン関数
// @breaf Random Walk with Restart(RWR) の cuSPARSE版 実装のメイン関数
// @param  argc, *argv[]
// @return 正常終了時 0
//         不正終了時 負数
//
int main(int argc, char *argv[]){
  // 引数の処理
  int opt = 0;
  string trans_mat; // 遷移行列ファイル
  string init_vec;  // 初期べベクトルファイル
  string alpha;     // alpha パラメータ ・・・ google matrix parameter
  string output;    // 出力ファイル
  
  // COO 形式で遷移行列を表現する(ホスト側)
  vector<int> h_rows;
  vector<int> h_columns;
  vector<double> h_values;
  
  // 初期ベクトル
  vector< vector<double> > h_vecs;
  
  // 引数parse
  while((opt = getopt(argc, argv,"i:v:o:a:")) != -1){
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
    case 'o':
      output = optarg;
      break;
    case ':':  // no value applied
    case '?':  // invalid option
      exit(1);
    }
  }
  // 引数不正の場合,usage を出して終了
  if(trans_mat.empty() || init_vec.empty() || alpha.empty() || output.empty()){
    cerr << "[error] usage: rwr -i <trans_mat> -v <init_vec> -a <alpha>  -o <output>" << endl;
    exit(-1);
  }
  
  // [ホスト処理]
  //  COO形式の行列要素を読み込む
  load_matrix(trans_mat.c_str(), h_rows, h_columns,h_values);
  //  初期ベクトルを読み込む
  load_vecs(init_vec.c_str(), h_vecs);
  
  // [デバイス側]
  // cuSPARSE のハンドルを作成
  cusparseHandle_t handle;
  cusparseCreate(&handle);
  
  // デバイス側でCOO形式のデバイスメモリを取得
  thrust::device_vector<int> d_rows(h_rows.size());
  thrust::device_vector<int> d_columns(h_columns.size());
  thrust::device_vector<double> d_values(h_values.size());
  
  // 行列Aのディスクリプタを記述
  cusparseMatDescr_t matDescr;
  cusparseCreateMatDescr(&matDescr);
  cusparseSetMatType(matDescr, CUSPARSE_MATRIX_TYPE_GENERAL);
  cusparseSetMatIndexBase(matDescr, CUSPARSE_INDEX_BASE_ZERO);
  
  // COO形式の行列データをGPUへオフロード
  // ホストベクトルをデバイスに転送
  thrust::copy_n(h_rows, h_rows.size(), d_rows.begin());
  thrust::copy_n(h_columns, h_columns.size(), d_columns.begin());
  thrust::copy_n(h_values, h_values.size(), d_values.begin());
  
  // CSR形式のベクトルを取得するためにデバイスメモリを確保
  // non-zero element
  int nnz    = h_values.size();
  int n_rows = max_element(h_rows.begin(), h_rows.end()); 
  thrust::device_vector<int> d_csr_valus(nnz);
  thrust::device_vector<int> d_csr_columns(nnz);
  thrust::device_vector<int> d_csr_rows(n_rows);
  // COO形式からCSR形式へ変換
  //cusparseDcoo2csr(handle, d_rows, nnz, 
  
  exit(0);
}
