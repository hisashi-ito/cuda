### cuSPARSE 行列変換サンプル
cuSPARSEを利用して行列の形式を変換するサンプルコード。  
本コードではCOO形式からCRS形式へ変換を実施する。サンプルとなる行列(M)は以下とする。  
```
3 0 0
6 0 0
0 2 1
```

#### COO(座標格納)方式
COO形式で行列(M)を保存すると
```
values = [3,6,2,1]
rows   = [0,0,1,2]
cols   = [0,1,2,2]
```
#### CSR(Compressed Sparse Row)方式
CSR形式で行列(M)を保存すると
```
values = [3,6,2,1]
cols   = [0,1,2,2]
rows   = [0,1,2,4]
```
のようになる。ここで留意点では　COO形式とCSR形式では values, cols は変換せずに　rowsの表現のみが異なる点である。
実施にcuSPARSE の変換ライブラリ
1. cusparse<t>coo2csr
```
cusparseStatus_t
cusparseXcoo2csr(cusparseHandle_t handle, const int *cooRowInd,
 int nnz, int m, int *csrRowPtr, cusparseIndexBase_t
 idxBase)
```
http://acarus.uson.mx/docs/cuda-5.5/CUSPARSE_Library.pdf  
では rows の変換だけが定義されている。他は変化ないから変換しなくてもよい。
