#!/usr/bin/env ruby -w

# ./00_step-by-step.rb <seq_maxsize> <n-step>

require_relative '../fib-interval'

$seq = []
$seq_maxsize = 6
$counter = 0

def show(del = nil)
  n = 3
  a = []
  $seq.each_with_index { | x, i |
    if del && (i == del)
      y = x.to_s
      space = ' ' * (n - 1 - y.length)
      a << (space + '*' + y)
    else
      a << sprintf("%#{n}d", x)
    end
  }
  puts "[#{a.join(', ')}] <- #{$counter}"
end

def get_intervals
  result = []
  prev = nil
  $seq.each { |x|
    result << (x - prev) if prev
    prev = x
  }
  result
end

def step
  $counter += 1
  del = nil
  del = FibInterval.index_to_delete get_intervals if $seq.size == $seq_maxsize
  show del
  $seq.delete_at del if del
  $seq << $counter
end

v = ARGV[0].to_i
$seq_maxsize = v if v >= 2
v = ARGV[1].to_i
n = ( v > 0 ) ? v : 50

fibs = FibInterval.generate_fibs($seq_maxsize - 1)
puts "fibs = #{fibs.join(', ')}"
sum = fibs.inject { | accum, x | accum += x }
puts "#{fibs.join(' + ')} = #{sum}"
puts "seq_maxsize = #{$seq_maxsize}"
puts "#{n} step#{'s' if n > 1}"
n.times { step }


### result ###
=begin
$ ruby 00_step-by-step.rb
fibs = 1, 2, 3, 5, 8
1 + 2 + 3 + 5 + 8 = 19
seq_maxsize = 6
50 steps
[] <- 1
[  1] <- 2
[  1,   2] <- 3
[  1,   2,   3] <- 4
[  1,   2,   3,   4] <- 5
[  1,   2,   3,   4,   5] <- 6
[  1,  *2,   3,   4,   5,   6] <- 7
[  1,  *3,   4,   5,   6,   7] <- 8
[  1,   4,  *5,   6,   7,   8] <- 9
[  1,  *4,   6,   7,   8,   9] <- 10
[  1,   6,  *7,   8,   9,  10] <- 11
[  1,   6,  *8,   9,  10,  11] <- 12
[  1,   6,   9, *10,  11,  12] <- 13
[  1,  *6,   9,  11,  12,  13] <- 14
[  1,   9, *11,  12,  13,  14] <- 15
[  1,   9,  12, *13,  14,  15] <- 16
[  1,   9, *12,  14,  15,  16] <- 17
[  1,   9,  14, *15,  16,  17] <- 18
[  1,   9,  14, *16,  17,  18] <- 19
[  1,   9,  14,  17, *18,  19] <- 20
[ *1,   9,  14,  17,  19,  20] <- 21
[  9, *14,  17,  19,  20,  21] <- 22
[  9,  17, *19,  20,  21,  22] <- 23
[  9,  17,  20, *21,  22,  23] <- 24
[  9,  17, *20,  22,  23,  24] <- 25
[  9,  17,  22, *23,  24,  25] <- 26
[  9,  17,  22, *24,  25,  26] <- 27
[  9,  17,  22,  25, *26,  27] <- 28
[ *9,  17,  22,  25,  27,  28] <- 29
[ 17, *22,  25,  27,  28,  29] <- 30
[ 17,  25, *27,  28,  29,  30] <- 31
[ 17,  25,  28, *29,  30,  31] <- 32
[ 17,  25, *28,  30,  31,  32] <- 33
[ 17,  25,  30, *31,  32,  33] <- 34
[ 17,  25,  30, *32,  33,  34] <- 35
[ 17,  25,  30,  33, *34,  35] <- 36
[*17,  25,  30,  33,  35,  36] <- 37
[ 25, *30,  33,  35,  36,  37] <- 38
[ 25,  33, *35,  36,  37,  38] <- 39
[ 25,  33,  36, *37,  38,  39] <- 40
[ 25,  33, *36,  38,  39,  40] <- 41
[ 25,  33,  38, *39,  40,  41] <- 42
[ 25,  33,  38, *40,  41,  42] <- 43
[ 25,  33,  38,  41, *42,  43] <- 44
[*25,  33,  38,  41,  43,  44] <- 45
[ 33, *38,  41,  43,  44,  45] <- 46
[ 33,  41, *43,  44,  45,  46] <- 47
[ 33,  41,  44, *45,  46,  47] <- 48
[ 33,  41, *44,  46,  47,  48] <- 49
[ 33,  41,  46, *47,  48,  49] <- 50
=end
