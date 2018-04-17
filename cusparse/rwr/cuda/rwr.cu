//
// Name: rwr.cu
//
// File Name:       rwr.cu  (definition)
// Definition file: rwr.h   (header)
//
// 概要: Random Walk with Restart (RWR)の計算を制御するクラス
//
// 更新履歴:
//          2018.04.10 新規作成
//          2018.04.17 推薦ベクトルの入力をminibach に変更する
//
#include "rwr.h"

// @constructor
//  コンストラクタ
Rwr::Rwr(string coo_file, string vec_file,int iteration,
	 double alpha, string output, int batch_size){
  // インスタンス変数の格納(一旦保存しておく)
  this->iteration  = iteration;
  this->alpha      = alpha;
  this->output     = output;
  this->batch_size = batch_size;
  this->util       = new Util();
  load_vecs(vec_file, this->vecs);                   // 推薦元ベクトル配列の読み込み
  this->diag = new Diag(coo_file, iteration, alpha); // 対角化インスタンスを作成
}

// @destructor
Rwr::~Rwr(void){}

// @calc
// @breaf 対角化を実施
//        推薦元ベクトルの計算時に1個つづ処理するのではなく
//        ミニバッチで指定した個数づつをGPUメモリに転送して処理する
void Rwr::calc(){
  // 入力ベクトル毎にバッチサイズに基づいてベクトルバッチを作成
  unsigned int cnt = 0;
  thrust::host_vector<double> vec;
  thrust::host_vector<double> ret;
  for(unsigned int i = 0; i < this->vecs.size(); i++){
    if(cnt < this->batch_size){
      // vecs 情報を1次元配列にマッピング
      for(unsigned int j = 0; j < this->vecs[i].size(); j++){
	vec.push_back(this->vecs[i][j]);
	ret.push_back(0.0);
      }
      cnt += 1;
    }else{
      // バッチサイズの上限に達したのでべき乗法にて対角化する
      diagonalize(vec, ret, this->vec_size);
      cnt = 0;
    }
  }
  // 余剰部分データを処理
  if(cnt != 0){ diagonalize(vec, ret, this->vec_size);}
}

// @diagonalize
//  対角化実行
// @break 対角化実行関数
//
void Rwr::diagonalize(thrust::host_vector<double> &vec,
		      thrust::host_vector<double> &ret,
		      int vec_size){
  vector<double> std_ret(vec_size);
  this->diag->power_method(vec, ret, vec_size);
  for(int j = 0; j < (int)ret.size()/vec_size; j++){
    int begin = j*vec_size;
    int end   = begin + vec_size - 1;
    thrust::copy(ret.begin () + begin, ret.begin() + end, std_ret.begin());
    string sret = this->util->join(std_ret);
    this->results.push_back(sret);
  }
}

// @write
// @breaf 計算した結果を出力する
void Rwr::write(){
  ofstream outputfile(this->output.c_str());
  for(unsigned int i = 0; i < this->results.size(); i++){
    outputfile << results[i] << endl;
  }
  outputfile.close();
}

// @load_vec
// @breaf 推薦元となる初期ベクトルを読み込む
// @params ファイル名<string>
//         初期ベクトル(vec)
// @return void
//   
void Rwr::load_vecs(string file, vector< vector<double> > &vecs){
  vector<double> tmp;
  string buff;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 初期ベクトルファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  // 初期ベクトルファイルの読み込み
  // フォーマット) 数値1<SP>数値2...
  while(getline(ifs, buff)){
    vector<string> elems = this->util->split(buff, ',');
    // ベクトルのサイズを保存取得しておく(初回だけ保存)
    if(this->vec_size == 0)
      this->vec_size = elems.size();
    
    for(unsigned int i = 0; i < elems.size(); i++){
      tmp.push_back((double)atof(elems[i].c_str()));
    }
    vecs.push_back(tmp);
    tmp.clear();
  }
}
