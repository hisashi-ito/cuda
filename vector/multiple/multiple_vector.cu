//
// 【normalize_vector】
//
//  概要: ベクトルの正規化関数サンプル
//        参考:
//        CUDA for Engineers: An Introduction to High-Performance Parallel Computing
//
#include <thrust/device_vector.h>
#include <thrust/inner_product.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <cmath>
#include <iostream>
using namespace std;

void normalize(thrust::device_vector<double> &v, double alpha){
  using namespace thrust::placeholders;
  thrust::transform(v.begin(), v.end(), v.begin(), _1 *= alpha);
}

int main(){
  thrust::device_vector<double> vec(2);
  vec[0] = 1.0;
  vec[1] = 2.0;
  // ベクトルの正規化
  normalize(vec, 0.5);
  // 確認
  for(int i = 0; i < vec.size(); i++){
    cout << "vec[" << i << "] = " << vec[i] << endl;
  }
}
