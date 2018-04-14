### Random Walk with Restart (RWR) CUDA実装  
レコメンドエンジンとして利用されることが多い Random Walk with Restart アルゴリズムの CUDA実装。  
本プログラムはCOO格納形式で保存された遷移行列と推薦元を表す特徴ベクトルを読み込み当該特徴ベクトルに対応した固有ベクトルを求める。プログラムのCUDAによる実装である。  

CUDAで利用したlibraryとしては cuSPARSE Level2のライブラリである空疎行列と密ベクトルの掛け算のライブラリを利用して実装を行った。その他、ホスト,デバイス側のメモリ管理を簡略化するためにThrustライブラリを利用している。

##### コンパイル方法
```
$ cd bin 
$ make
```
コンパイル時にはGPUアーキテクチャを指定するオプション(-arch)が指定できる。このオプションは利用環境に依存する。  
どのようなオプションを押下するかは以下のWEBで記載されている。  h
http://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/  

引用すると以下のようになっている  

```
Fermi (CUDA 3.2 and later, deprecated from CUDA 9):
SM20 or SM_20, compute_30 – Older cards such as GeForce 400, 500, 600, GT-630
Kepler (CUDA 5 and later):
SM30 or SM_30, compute_30 – Kepler architecture (generic – Tesla K40/K80, GeForce 700, GT-730)
Adds support for unified memory programming
SM35 or SM_35, compute_35 – More specific Tesla K40
Adds support for dynamic parallelism. Shows no real benefit over SM30 in my experience.
SM37 or SM_37, compute_37 – More specific Tesla K80
Adds a few more registers. Shows no real benefit over SM30 in my experience
Maxwell (CUDA 6 and later):
SM50 or SM_50, compute_50 – Tesla/Quadro M series
SM52 or SM_52, compute_52 – Quadro M6000 , GeForce 900, GTX-970, GTX-980, GTX Titan X
SM53 or SM_53, compute_53 – Tegra (Jetson) TX1 / Tegra X1
Pascal (CUDA 8 and later)
SM60 or SM_60, compute_60 – GP100/Tesla P100 – DGX-1 (Generic Pascal)
SM61 or SM_61, compute_61 – GTX 1080, GTX 1070, GTX 1060, GTX 1050, GTX 1030, Titan Xp, Tesla P40, Tesla P4
SM62 or SM_62, compute_62 – Drive-PX2, Tegra (Jetson) TX2, Denver-based GPU
Volta (CUDA 9 and later)
SM70 or SM_70, compute_70 – Tesla V100
SM71 or SM_71, compute_71 – probably not implemented
SM72 or SM_72, compute_72 – currently unknown
```

本プログラムでは自分の環境である SM62 を指定している。　　

※ 実行環境に nvcc および、 cuSPARSEがインストールされていることを想定とします。

##### 実行方法
```
$ ./rwr -i <遷移行列> (COO格納形式) -v <初期ベクトルファイル> -a <rwrのalphaパラメータ> -t <iteratoin回数> -o <出力ファイル>
```
##### ファイルフォーマット
1. 遷移行列(COO格納形式)  
計算で利用する遷移行列をCOO形式で保存する。フィールドセパレータはカンマ','文字列とする
```
0,0,1.0
0,1,2.0
0,2,3.0
1,0,4.0
1,1,5.0
1,2,6.0
2,0,7.0
2,1.8.0
2,2,9.0
```
2. 初期ベクトルファイル(推薦元ベクトル)  
推薦元となる情報を表現した特徴ベクトルのリストを与える。２つの推薦データを作成するのであれば以下のように２行で表現する。本質的に推薦元ベクトルは密ベクトルである。ファイルセパレーターは ',' カンマとする。
```
0.1,0.2,0.3 # 1つ目の推薦元データ（初期ベクトル)
0,0.4,0.8   # 2つ目の推薦元データ（初期ベクトル)
```
3. rwrのαパラメータ  
rwrを計算するときにハイパーパラメータ。0から1までのdoubleで指定する。alphaが小さいと推薦自のパーソナライズ効果が強くなる。逆に大きいと人気度が高いものが出力される。  

4. iteration回数  
べき乗法でベクトルを乗算する回数。上記のαパラメータと関連があるが、１０〜２０程度でよい。  

5. 出力ファイル  
以下の形式で出力する。それぞれの固有ベクトルの値が出力される。
```
0.0502512,0.890931,0.45135　# 1つ目のデータの固有ベクトル
0.141171,0.819256,0.555779  # 2つ目のデータの固有ベクトル
```
##### 補足  
環境によってはcuSPARSEライブラリにライブラリパスが通ってないかもしれませんのでその場合は環境設定で以下の設定を実施しておく。
```
LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/local/cuda-7.5/lib64;
export LD_LIBRARY_PATH
```
##### benchmark  
cuda実装のものとeigen3実装のrwrのコードを作成したので、同じファイルを読み込み計算時間を両者で評価した。
1. 実験環境  
Jetson TK2
GPU: NVIDIA Pascal, 256 NVIDIA CUDA Cores  
CPU: Dual Denver 2/2MB L2 +Quad ARM® A57/2MB L2  
2. 実験環境
```
遷移行列サイズ: 93,751 x 93,750  
推定データ数: 100  
べき乗法の繰り返し回数(iteration): 30  
alpha: 0.85  
```
3. 実験パラメータ  
[1] CPU(einge3)で最適化なし  
[2] CPU(einge3)でO3最適化  
[3] GPU(cuda)で最適化なし  
[4] GPU(cuda)でO3最適化  

4. 結果
<p align="center">
<img src="https://user-images.githubusercontent.com/8604827/38763042-bd7c9862-3fce-11e8-8a30-0cd64ae2afa5.jpg" width="600px">
</p>
基本的にはGPU実装が速いがeigen3の最適化後もかなり高速。
