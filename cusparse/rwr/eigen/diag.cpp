//
// Name: diag
//
// File Name:   diag.cpp (definition file)
// Header file: dig.h    (header file)
//
// 概要: 対角化を実行するクラス
//       対角化法はPOWER MTHOD のみを扱う
//       (厳密にはさgoogle matrixを対角化する)
//       行列の演算にはEigen3を利用する
//
// 更新履歴:
//          2018.04.03 新規作成
//
#include "diag.h"

// @constructor
//  コンストラクタ
// @param: coo_file   行列(COO形式)ファイル名
// @param: iteration  冪情報の繰り返し回数
// @param: aplha      google パラメータ
//
Diag::Diag(const string coo_file, int iteration, double alpha){
  // パラメータをインスタンス変数へ保存する
  this->iteration = iteration;
  this->alpha = alpha;
  this->util  = new Util();

  // 行列の読み込み用ベクトルを用意
  vector< Triplet<double> > tvec;

  // COO形式の行列を読み込み、変換前の中間ベクトルとして
  // Triplet<double> のベクトルを取得する
  load_matrix(coo_file, tvec);
  
  // sparse行列を作成し、メモリ上に保存する
  // row_size,col_size はCOO形式のindexが0-originなので
  // サイズにするには+1する必要がある。
  this->A = SparseMatrix<double>(row_size+1, col_size+1);
  this->A.setFromTriplets(tvec.begin(), tvec.end());
}

// @destructor
//  デストラクタ
Diag::~Diag(void){
  // 行列要素等をfreeすべきだが、thrustを
  // 利用しているので自動で返却される
}

// @load_matrix
//  行列読み込み関数
// @breaf: COO形式の行列を読み込む。読み込み後はrows, cols, vals に保存される
// @param: file 行列(COO形式)ファイル名
// @param: トリプレットベクトル(row,col,valがトリプレットで保存)
//
void Diag::load_matrix(const string file, vector< Triplet<double> > &tvec){
  string buff;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 遷移行列のファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  // 遷移行列の読み込み
  // row, colums でソートされていることを期待します!
  // フォーマット) row,column,value
  while(getline(ifs, buff)){
    vector<string> elems = this->util->split(buff, ',');
    int row    = atoi(elems[0].c_str());
    int col    = atoi(elems[1].c_str());
    double val = (double)atof(elems[2].c_str());
    // row, colのサイズを求める(読み込んだら更新しておく)
    if(row > this->row_size){this->row_size = row;}
    if(col > this->col_size){this->col_size = col;}
    tvec.push_back(Triplet<double>(row, col, val));
  }
}

// @power_method
//  冪乗法
// @breaf: 対角化関数、実際にはG-matrix を対角化する
// @param: 推薦元の初期ベクトル
// @param: 計算結果ベクトル(固有Vector) 
//
void Diag::power_method(VectorXd &x, VectorXd &y){
  double beta = 1.0 - this->alpha;
  VectorXd init_x = beta * x; // beta(1-alpha) * init_x (deep copy)
  // iteration
  for(int i = 0; i < this->iteration; i++){
    // y = alpha ∗ A ∗ x
    y = this->alpha * A * x;
    // y += (β * init_x)
    y = y + init_x;
    // y をnormalizeする
    y.normalize();
    // 入れ替える
    x = y;
  }
}

#ifdef _DEBUG_
int main(){
  int array_size = 3;
  VectorXd a(array_size);
  VectorXd b(array_size);
  // 入力 vectorの初期化
  a[0] = 0.1;
  a[1] = 0.2;
  a[2] = 0.3;
  b[0] = 0.0;
  b[1] = 0.0;
  b[2] = 0.0;
  Diag *diag = new Diag("../data/matirx.tsv", 5, 0.85);
  diag->power_method(a, b);
  // 計算結果を表示
  for(int i = 0; i < 3; i++){
    cout << "b[" << i << "]= " << b[i] <<endl;
  }
  exit(0);
}
#endif /*_DEBUG_*/
