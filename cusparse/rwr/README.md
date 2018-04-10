### Random Walk with Restart (RWR) の実装  
レコメンドエンジンとして利用できる Random Walk with Restart の CUDA実装。  
本プログラムはCOO格納形式で保存された遷移行列(M)を読み込み、推薦元を表す特徴ベクトルを読み込み当該特徴ベクトルに一番近い特徴ベクトルのIDを返却するシンプルなプログラムである。  
