//
// Name: diag
//
// File Name:   diag.cu (definition file)
// Header file: dig.h   (header file)
//
// 概要: 対角化を実行するクラス
//       対角化法はPOWER MTHOD のみを扱う
//       (厳密にはさgoogle matrixを対角化する)
//
//       CUDA のポインタ管理には thrustを利用する
//
// 更新履歴:
//          2018.04.03 新規作成
//
#include 'diag.h'

// @constructor
//  コンストラクタ
// @param: coo_file   行列(COO形式)ファイル名
// @param: iteration  冪情報の繰り返し回数
// @param: aplha      google パラメータ
//
Diag::Diag(const string coo_file, int iteration, double alpha){
  // パラメータをインスタンス変数へ保存する
  this->iteration = iteration;
  this->alpha     = alpha;
  
  // [ホスト側]
  //  COO形式の行列を読み込む 
  load_matrix(coo_file, this->h_rows, this->h_cols, this->h_vals);
  
  // デバイス側の準備
  // cuSPARSE のハンドルを作成
  cusparseHandle_t handle;
  cusparseCreate(&handle);
  
  // non-zero 要素数
  this->nnz = this->h_vals.size();
  this->row_size = *max_element(h_rows.begin(), h_rows.end()) ; // 変換前の行列の行数(rows)
  this->col_size = *max_element(h_cols.begin(), h_cols.end());  // 変換前の行列の行数(colms)
  
  // デバイス側でCOO形式のデバイスメモリを取得
  // ただし、CSR形式への変換はh_vals, h_cols は変更必要ない。
  // h_rows だけが変更がなされる
  thrust::device_vector<int>    d_csr_cols = h_cols;
  thrust::device_vector<double> d_csr_vals = h_vals;
  thrust::device_vector<int> d_rows = h_rows;
  thrust::device_vector<int> d_csr_rows(this->row_size+1);
  
  // 行列のディスクリプタを記述
  cusparseMatDescr_t matDescr;
  cusparseCreateMatDescr(&matDescr);
  cusparseSetMatType(matDescr, CUSPARSE_MATRIX_TYPE_GENERAL);
  cusparseSetMatIndexBase(matDescr, CUSPARSE_INDEX_BASE_ZERO);

  // COO->CSR 形式へ変換(rowsだけ)
  cusparseXcoo2csr(handle, thrust::raw_pointer_cast(&d_rows[0]),
		   this->nnz, this->row_size,
		   thrust::raw_pointer_cast(&d_csr_rows[0]),
		   CUSPARSE_INDEX_BASE_ZERO);
}

// @destructor
//  デストラクタ
Diag::~Diag(void){
  // 行列要素等をfreeすべきだが、thrustを
  // 利用しているので自動で返却される
}

// @split
//  文字列分割関数
// @breaf 指定のデリミネタを利用してstringの文字列を分割する
//        分割された文字列は vector<string> 文字列に格納される
// @param 文字列(string)
// @param 分割デリミネタ(char)
// @return 分割された文字列が vector<string>で返却される
//
vector<string> Diag::split(const string &s, char delim){
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

// @load_matrix
//  行列読み込み関数
// @breaf: COO形式の行列を読み込む。読み込み後はrows, cols, vals に保存される
// @param: file 行列(COO形式)ファイル名
// @param: rows, cols, vals (COO行列のベクトル)
//
void Diag::load_matrix(const string file, thrust::host_vector<int> &rows, 
		       thrust::host_vector<int> &cols, thrust::host_vector<double> &vals){
  string buff;
  ifstream ifs(file.c_str());
  if(ifs.fail()){
    cerr << "[error] 遷移行列のファイルの読み込みに失敗しました" << endl;
    exit(-1);
  }
  // 遷移行列の読み込み
  // row, colums でソートされていることを期待します!
  // フォーマット) row<TAB>column<TAB>value
  while(getline(ifs, buff)){
    vector<string> elems = split(buff, '\t');
    int row    = atoi(elems[0].c_str());
    int col    = atoi(elems[1].c_str());
    double val = (double)atof(elems[2].c_str());
    // vector へpushする
    rows.push_back(row);
    cols.push_back(col);
    vals.push_back(val);
  }
}

// @power_method
//  冪乗法
// @breaf: 対角化関数、実際にはG-matrix を対角化する
// @param: 
//
void Diag::power_method(thrust::host_vector<double> &x, 
			thrust::host_vector<double> &y){
  // ベクトル情報をGPUへオフロード
  thrust::device_vector<double> x = x;          
  thrust::device_vector<double> init_x(x.size());
  thrust::device_vector<double> y(x.size());
  
  // xをinit_x にdeep copyする
  thrust::copy(x.begin(), x.end(), init_x);
  // init_x をbeta 倍する
  const_multiplies(init_x, beta);
  
  // cuSPARSE のハンドルを作成(必要ないかもしれない) 
  cusparseHandle_t handle;
  cusparseCreate(&handle);
  cusparseMatDescr_t matDescr;
  cusparseCreateMatDescr(&matDescr);
  cusparseSetMatType(matDescr, CUSPARSE_MATRIX_TYPE_GENERAL);
  cusparseSetMatIndexBase(matDescr, CUSPARSE_INDEX_BASE_ZERO);
  
  double* _x = thrust::raw_pointer_cast(&(x[0]));
  double* _y = thrust::raw_pointer_cast(&(y[0]));
  double* _d_csr_vals = thrust::raw_pointer_cast(&(d_csr_vals[0]));
  double* _d_csr_cols = thrust::raw_pointer_cast(&(d_csr_cols[0]));
  double* _d_csr_rows = thrust::raw_pointer_cast(&(d_csr_rows[0]));
  double beta  = 1.0 - this->alpha;
  double dummy = 0.0;
  
  for(int i = 0; i < this->iteration, i++){
    // y = α ∗ A ∗ x + (0 * y)
    cusparseDcsrmv(handle, CUSPARSE_OPERATION_NON_TRANSPOSE,
		   this->row_size, this->col_size, this->nnz,
		   &this->alpha, matDescr,
		   _d_csr_vals, _d_csr_rows, _d_csr_cols,
		   _x, &dummy, _y);
    
    // デバイスポインタの変換
    x = thrust::raw_pointer_cast(&(_x[0]));
    y = thrust::raw_pointer_cast(&(_y[0]));
    // y += (β * init_x)
    thrust::transform(y.begin(), y.end(), init_x.begin(), y.begin(),thrust::plus<double>());
    // y をnormalizeする
    normalize(y);
    // y → x
    thrust::copy(y.begin(), y.end(), x);
    // デバイスポインタへ戻す
    _x = thrust::raw_pointer_cast(&(x[0]));
    _y = thrust::raw_pointer_cast(&(y[0]));
  }
  // デバイスから計算結果を返却
  thrust::copy_n(_y.begin(), _y.end(), y);
}

// @normalize
//  行列の正規化関数
// @breaf: ベクトルを正規化する
// @param: ベクトル
//
void Diag::normalize(thrust::device_vector<double> &v){
  double norm = sqrt(thrust::inner_product(v.begin(), v.end(), v.begin(), 0.0));
  using namespace thrust::placeholders;
  thrust::transform(v.begin(), v.end(), v.begin(), _1 /= norm);
}

// @const_multiplies
//  ベクトルの低数倍
// @bread: 行列を低数倍する
// @param: ベクトル
//
void Diag::const_multiplies(thrust::device_vector<double> &v, double alpha){
  using namespace thrust::placeholders;
  thrust::transform(v.begin(), v.end(), v.begin(), _1 *= alpha);
}
