#### Sparse Matrix Vector multipilication benchmark  
Eigen3を利用してSpMV計算を実行し、１回の計算にかかる計算時間を測定するベンチマークプログラム。  
F
本プログラムはCOO形式の行列を読み込みEigen3ライブラリによりCRS形式へ変換する。その後、SpMV計算を実行し、1回のSpMV計算にかかる計算時間(msec)を測定するものである。 本実装はEigen3ライブラリを用いて実装している。Eigenライブラリは高速に動作し、ライブラリがヘッダファイルで提供されているのでコンパイル時に利用ヘッダファイルをリンクするだけで利用できる。また本実装はOpenMPによるマルチスレッド実行に対応している。  

##### Eigen3 について
Eigen  
http://eigen.tuxfamily.org/index.php?title=Main_Page  
最新のバージョは3.3.4  

##### 並列化(OpenMP)の方針
本実装は以下に示すシンプルなOpenMPによるマルチスレッド計算に対応している。並列化ではまず、共有メモリに行列を保存する。保存された共有メモリに対して複数の異なる密ベクトルをマルチスレッドで指定回数乗算する。概念図で記載すると以下のようになる。  

<p align="center">
<img src="https://user-images.githubusercontent.com/8604827/40163477-d869a11e-59f1-11e8-97df-1e20244c6f58.png" width="450px">
</p>

ここで、行列は１つのホストの共有メモリに保存されるものとし、この状況下で複数のCPU、上記の図では３つのCPUで並列化を実施している。上記の例では３つのCPUでSpMV計算を実行するためのベクトルを事前に10個用意されているとする。 ここで、CPU1は ベクトル1..4. CPU2はベクトル5..7, CPU3はベクトル8..10の処理を受け持つとする。このベクトルの個数というのが引数(-n)で指定する数値となっている。一般的にCPUの個数の粒度を揃えるためには

```
利用するCPUの個数 << n (初期ベクトル数)
```
であることが期待される。インテル社のi7CPUだと8コア程度なので、デフォルトではだいたい100ぐらいを想定しておけばCPUに割り当てられるタスクの粒度を揃えることができる。

##### 繰り返し回数の意味
引数で-tで入れている繰り返し回数は1回のspmv計算の平均計算時間計測するために繰り返し実行して、繰り返した回数の平均を取る。
```
// spmv 計算 (指定された回数計算します)
for(int i = 0; i < this->iteration; i++){
  y = this->A * x;
}
```
##### 初期ベクトルの作り方
初期ベクトルは計算前に一様乱数で初期化して生成している。繰り返し計算中は初期ベクトルは使い回し（キャッシュにのっているはず）

##### 計算時間の定義
OpenMPで複数プロセスで実行したときを考慮して、最終的な本プログラムが出力する計算時間の定義は以下とする
```
計算時間[msec] = 総計算時間[msec] / 繰り返し計算数(t) / 初期ベクトルの個数(n) 
```
総計算時間は行列の読み込みなどの初期化の時間は除く。初期ベクトルは乱数で計算最初に計算しているのだが、この部分は総計算時間に含まれる。SpMV計算に対して初期ベクトルを作成する時間は圧倒的に短時間である点を考慮して今回は無視する。

##### コンパイル方法
```
$ cd src/
$ make
```
※ 実行環境には g++ がインストールされていることを想定とする。

##### 実行方法
```
$ ./SPMV -i <行列> (COO格納形式) -t <iteratoin回数> -n <初期ベクトルの数>
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
2. iteratoin回数   
spmv計算を繰り返し実施し、平均をとるため設定する数値、100程度を想定している。  
平均をとるための繰り返し回数。デフォルトで100程度。

3. 初期ベクトルの数  
計算に利用する初期ベクトルの個数。デフォルトで100程度。

4. 出力  
標準出力に以下のような出力が出力される。
例）
```
*** 計測を開始します ***
初期ベクトルの本数:100
1回あたりの繰り返し回数:100
総処理時間[sec]: XXXX
1回あたりの平均時間[msec]: YYYY
*** 計測が完了しました ***
```
5. OpenMPのプロセス数の設定方法  
OpenMPのプロセス数の設定方法は環境変数に以下の変数を設定して実現するものとする。

```
export OMP_NUM_THREADS=${CPU数}
```
