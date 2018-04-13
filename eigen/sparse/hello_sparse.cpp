//
// 【hello_sparse】
// 
//  概要: Einge/Spase のサンプルコード
//
#include <iostream>
#include <vector>
#include <Eigen/Sparse>

using namespace std;
using namespace Eigen;

int main(){
  // Eigenのトリプレットでベクトルを作成
  vector< Triplet<double> > tripletVec;
  
  // COO 形式で格納する
  tripletVec.push_back(Triplet<double>(0,0,0.2));
  tripletVec.push_back(Triplet<double>(0,1,0.3));
  tripletVec.push_back(Triplet<double>(1,0,0.4));
  tripletVec.push_back(Triplet<double>(1,1,0.5));
  
  // 空疎行列に変換
  SparseMatrix<double> M(2,2);
  M.setFromTriplets(tripletVec.begin(), tripletVec.end());
  
  // 2次元配列の初期化
  Vector2d v;
  v << 1.0,1.0;
  
  // const で出力できる!
  cout << "M*v = \n" << M*v << endl;
}
