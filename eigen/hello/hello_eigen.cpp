//
// 【hello_eigen】
// 
//  概要: Einge のサンプルコード
//
#include <iostream>
#include <Eigen/Core>

using namespace std;
using namespace Eigen;

int main(){
  MatrixXd m(2,2);
  m(0,0) = 1.0;
  m(0,1) = 2.0;
  m(1,0) = 3.0;
  m(1,1) = 4.0;
  // const で出力できる!
  cout << "m = \n" << m << endl;
}
