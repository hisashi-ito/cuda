### CUDAを利用したベクトルの正規化
CUDAを利用したベクトルの正規化関数の実装例。  
参考にした出典は以下の本  
__CUDA for Engineers: An Introduction to High-Performance Parallel Computing__
https://www.amazon.co.jp/dp/B017HXS0J0/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1  

以下の２次元のベクトルがあったら
```
vec[0] = 1.0
vec[1] = 2.0
```
正規化は
```
norm = sqrt(vec[0]^2 + vec[1]^2)
vec = 1.0 /norm
```
なので以下の通りとなる
```
vec[0] = 0.447213595
vec[1] = 0.894427191
```
