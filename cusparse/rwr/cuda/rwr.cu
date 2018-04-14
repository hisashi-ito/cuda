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
//
#include "rwr.h"

// @constructor
//  コンストラクタ
Rwr::Rwr(string coo_file, string vec_file,int iteration, double alpha, string output){
  // インスタンス変数の格納(一旦保存しておく)
  this->iteration = iteration;
  this->alpha     = alpha;
  this->output    = output;
  this->util      = new Util();
  load_vecs(vec_file, this->vecs);                   // 推薦元ベクトル配列の読み込み
  this->diag = new Diag(coo_file, iteration, alpha); // 対角化インスタンスを作成
}

// @destructor
Rwr::~Rwr(void){}

// @calc
// @breaf 対角化を実施 
void Rwr::calc(){
  // 入力ベクトル毎(推薦レコード毎)に対角化を実施
  for(unsigned int i = 0; i < this->vecs.size(); i++){
    thrust::host_vector<double> vec = vecs[i];
    thrust::host_vector<double> ret(vecs[i].size(), 0.0);
    vector<double> std_ret(vecs[i].size());

    // べき乗法にて対角化する
    diag->power_method(vec, ret);

    // 結果を格納する
    thrust::copy(ret.begin(), ret.end(), std_ret.begin());
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
    for(unsigned int i = 0; i < elems.size(); i++){
      tmp.push_back((double)atof(elems[i].c_str()));
    }
    vecs.push_back(tmp);
    tmp.clear();
  }
}
