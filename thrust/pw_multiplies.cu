//
// 【pw_multiplies】
//
//  概要: thrust のサンプルコード
//        vector の同じ要素同士の掛け算を計算する
//        pointwise multiplication 計算
//
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/transform.h>
#include <iostream>

int main(){
  // ホスト側のメモリを確保
  thrust::host_vector<int> h_A(3);
  thrust::host_vector<int> h_B(3);
  thrust::host_vector<int> h_C(3);  

  // 適合に初期化する
  for(int i = 0; i<3; i++){
    h_A[i] = i;
    h_B[i] = i+3;
  }
  // device 側のメモリを確保
  thrust::device_vector<int> d_A(3);
  thrust::device_vector<int> d_B(3);
  thrust::device_vector<int> d_C(3);
  
  // GPU(device)側へデータを転送
  thrust::copy(h_A.begin(), h_A.end(), d_A.begin());
  thrust::copy(h_B.begin(), h_B.end(), d_B.begin());
  
  // pointwise multiplicationの計算
  // カーネル関数を直接記載しなくても計算できる(ゆとり...)
  thrust::transform(d_A.begin(), d_A.end(), d_B.begin(), d_C.begin(), thrust::multiplies<int>());
  
  // device側からhost側へ転送
  thrust::copy(d_C.begin(), d_C.end(), h_C.begin());
  
  // 確認
  std::cout << h_C[0] << ", " << h_C[1] << ", " << h_C[2] << std::endl;
  return(0);
}
