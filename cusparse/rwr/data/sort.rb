#! /usr/local/bin/ruby19
# -*- coding: utf-8 -*-
mat = {}

while line = gets
  elems = line.chomp.encode("utf-8").split("\t",-1)
  row = elems[0].to_i
  col = elems[1].to_i
  val = elems[2].to_f
  mat[row] ||= {}
  mat[row][col] = val
end

# row -> col でソートして出力する
mat.sort.each do |row, shash|
  shash.sort.each do |col, val|
    puts "#{row},#{col},#{val}"
  end
end
