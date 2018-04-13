### Random Walk with Restart (RWR) Eigen実装  
レコメンドエンジンとして利用されることが多い Random Walk with Restart アルゴリズムの Eigen実装。
本プログラムはCOO格納形式で保存された遷移行列と推薦元を表す特徴ベクトルを読み込み当該特徴ベクトルに対応した固有ベクトルを求める。プログラムのCUDAによる実装との速度比較のために実装する。  

##### Eigenについて
EigenはC++の行列演算を直感的な記述方式で実装できるテンプレートライブラリである。  
Eigenの公式HPはこちら  
http://eigen.tuxfamily.org/index.php?title=Main_Page  
最新版は Eigen 3.3.4 で本ライブラリはヘッダファイルのみで提供されるのでコンパイル時にインクルードするだけで利用できる点が便利である。    

参考文献  (暗黒通信団)  
http://ankokudan.org/d/dl/pdf/pdf-eigennote.pdf  
クラスの命名規則については非常に明快である。  
