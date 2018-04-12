#! /usr/local/bin/ruby19
# -*- coding: utf-8 -*-
#
# 【rvec.rb】
#      
#  概要: 指定された次元のrandomなベクトルをN個作成する
# 
#  usage: rvec.rb -N <次元数> -n <出力数>
#
require 'optparse'
require 'time'

# ベクトルを正規化する
def normalize(v)
  norm = 0
  ret  = []
  v.map{|x| norm += x*x}
  norm = 1.0 / Math.sqrt(norm)
  
  v.each do |x|
    ret.push(norm * x)
  end
  return ret
end

def main(argv)
  param = argv.getopts("N:n:")
  dim = param["N"].to_i
  num = param["n"].to_i
  # seed としてprocess番号を渡す
  r = Random.new(Time::now.to_i + $$)
  
  # N 次元のベクトルデータを作成する
  vecs = []
  0.upto(num - 1){|_,|
    vec = []
    0.upto(dim - 1){|__,|
      vec.push(r.rand)
    }
    vec = normalize(vec)
    vecs.push(vec.dup)
  }
  # 出力する
  vecs.each do |vec|
    puts("#{vec.join(",")}")
  end
end

if __FILE__ == $0
  main(ARGV)
end
