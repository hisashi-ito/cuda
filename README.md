### CUDA のサンプルコード

<p align="center">
<img src="https://user-images.githubusercontent.com/8604827/37657836-6aaffc3e-2c8f-11e8-8002-17f7cabc3d9f.png" width="300px">
</p>

#### 1.はじめに  
本リポジトリはCUDAコードの学習用のサンプル置き場  
参考書は「CUDA C プロフェッショナル プログラミング」(impress)

#### 2.ディレクトリ構成
* hello  
hello world コード
* sumArray  
ベクトルの和のサンプル。乱数で初期化かしたベクトル2つのベクトル(A,B)の和をGPUで計算し、計算があているかホスト側で計算したものと比べてチェックします。
* check_dimension  
グリッド,ブロック,スレッドの確認サンプル  

* thrust  
Thrustを利用したサンプルコード  

### 3. 各コマンドのビルド方法
```
$ make
```
留意点) nvcc がインストールされていることを想定
