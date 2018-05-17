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
#include "spmv.h"

// @constructor
Spmv::Spmv(const string coo_file, const int iteration){
  this->util      = new Util();
  this->iteration = iteration;
  // 遷移行列の読み込み用ベクトルを用意
  vector< Triplet<float> > tvec;
  // COO 形式行列を読み込む
  this->load_matrix(coo_file, tvec);
  // sparse行列を作成し、メモリ上に保存する
  this->A = SparseMatrix<float>(this->row_size, this->col_size);
  this->A.setFromTriplets(tvec.begin(), tvec.end());
}

// @destructor
Spmv::~Spmv(void){}

// @load_matrix
//  行列読み込み関数
// @breaf: COO 形式の行列を読み込む。読み込み後はrows, cols, vals に保存される
// @param: file 行列(COO 形式)ファイル名
// @param: トリプレットベクトル(row,col,valがトリプレットで保存)
//
void Spmv::load_matrix(const string file, vector< Triplet<float> > &tvec){
  string buff;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 遷移行列(COO 形式) のファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  // 遷移行列の読み込み
  // row, colums でソートされていることを期待します!
  // フォーマット) row,column,value
  while(getline(ifs, buff)){
    // 各行成分のデリミタはカンマ","
    vector<string> elems = this->util->split(buff, ',');
    int row    = atoi(elems[0].c_str());
    int col    = atoi(elems[1].c_str());
    float val = (float)atof(elems[2].c_str());
    // row, colのサイズを求める(読み込んだら更新しておく)
    if(row > this->row_size){this->row_size = row;}
    if(col > this->col_size){this->col_size = col;}
    tvec.push_back(Triplet<float>(row, col, val));
  }
  // 結構微妙な感じだけど。。
  // 行列データのインデクス番号は0-originなので
  // 最大の数値+1が実際のサイズとなる
  // 最後にrow,colを+1する 
  this->row_size += 1;
  this->col_size += 1;
}

// @make_init_vec
//  初期ベクトル作成
// @breaf spmv計算を実施する場合の初期ベクトルを乱数を用いて作成する
//        初期ベクトルは一様乱数を用いて乱数で初期化する
//        とりあえず、初期ベクトルの規格化はなしとする(とりあえず)
//        初期ベクトルのサイズは row_size とする
// @params
//        なし
// @return
//        vector<float>
//
VectorXf Spmv::make_init_vec(){
  VectorXf vec(this->row_size);
  for(unsigned int i = 0; i < this->row_size; i++){
    // rand 関数でええやろ。
    vec[i] = ((float)rand()+1.0)/((float)RAND_MAX+2.0);
  }
  return vec;
}

// @calc
//  メイン計算部分(ベンチマーク部分)
// @breaf
//  spmv計算を指定された回数(iteration)実行する
//
void Spmv::calc(){
  // 初期ベクトルと計算結果ベクタを作成
  VectorXf x = this->make_init_vec();
  VectorXf y(this->row_size);
  // spmv 計算 (指定された回数計算します)
  for(int i = 0; i < this->iteration; i++){
    y = this->A * x;
  }
}
