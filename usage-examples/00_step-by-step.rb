#!/usr/bin/env ruby -w

# ./00_step-by-step.rb <list_maxsize> <n-step>

# MURAKAMI Teiji
# https://github.com/murakamit/fib-interval

require_relative '../fib-interval'

$list = []
$list_maxsize = 6
$counter = 0

def get_intervals
  result = []
  prev = nil
  $list.each { |x|
    result << (x - prev) if prev
    prev = x
  }
  result
end

def show(del = nil)
  n = 3
  a = get_intervals.map { |x|
    y = x.to_s
    space = ' ' * (n - y.length)
    space + y
  }
  s = '(' + a.join(', ') + ')'
  a = []
  $list.each_with_index { | x, i |
    if del && (i == del)
      y = x.to_s
      space = ' ' * (n - 1 - y.length)
      a << (space + '*' + y)
    else
      a << sprintf("%#{n}d", x)
    end
  }
  puts "#{s} [#{a.join(', ')}] <- #{$counter}"
end

def step
  $counter += 1
  del = nil
  del = FibInterval.index_to_delete get_intervals if $list.size == $list_maxsize
  show del
  $list.delete_at del if del
  $list << $counter
end

v = ARGV[0].to_i
$list_maxsize = v if v >= 2
v = ARGV[1].to_i
n = ( v > 0 ) ? v : 50

fibs = FibInterval.generate_fibs($list_maxsize - 1)
puts "fibs = #{fibs.join(', ')}"
sum = fibs.inject { | accum, x | accum += x }
puts "#{fibs.join(' + ')} = #{sum}"
puts "list_maxsize = #{$list_maxsize}"
puts "#{n} step#{'s' if n > 1}"
n.times { step }


### result ###
=begin
$ ruby 00_step-by-step.rb
fibs = 1, 2, 3, 5, 8
1 + 2 + 3 + 5 + 8 = 19
list_maxsize = 6
50 steps
() [] <- 1
() [  1] <- 2
(  1) [  1,   2] <- 3
(  1,   1) [  1,   2,   3] <- 4
(  1,   1,   1) [  1,   2,   3,   4] <- 5
(  1,   1,   1,   1) [  1,   2,   3,   4,   5] <- 6
(  1,   1,   1,   1,   1) [  1,  *2,   3,   4,   5,   6] <- 7
(  2,   1,   1,   1,   1) [  1,  *3,   4,   5,   6,   7] <- 8
(  3,   1,   1,   1,   1) [  1,   4,  *5,   6,   7,   8] <- 9
(  3,   2,   1,   1,   1) [  1,  *4,   6,   7,   8,   9] <- 10
(  5,   1,   1,   1,   1) [  1,   6,  *7,   8,   9,  10] <- 11
(  5,   2,   1,   1,   1) [  1,   6,  *8,   9,  10,  11] <- 12
(  5,   3,   1,   1,   1) [  1,   6,   9, *10,  11,  12] <- 13
(  5,   3,   2,   1,   1) [  1,  *6,   9,  11,  12,  13] <- 14
(  8,   2,   1,   1,   1) [  1,   9, *11,  12,  13,  14] <- 15
(  8,   3,   1,   1,   1) [  1,   9,  12, *13,  14,  15] <- 16
(  8,   3,   2,   1,   1) [  1,   9, *12,  14,  15,  16] <- 17
(  8,   5,   1,   1,   1) [  1,   9,  14, *15,  16,  17] <- 18
(  8,   5,   2,   1,   1) [  1,   9,  14, *16,  17,  18] <- 19
(  8,   5,   3,   1,   1) [  1,   9,  14,  17, *18,  19] <- 20
(  8,   5,   3,   2,   1) [ *1,   9,  14,  17,  19,  20] <- 21
(  5,   3,   2,   1,   1) [  9, *14,  17,  19,  20,  21] <- 22
(  8,   2,   1,   1,   1) [  9,  17, *19,  20,  21,  22] <- 23
(  8,   3,   1,   1,   1) [  9,  17,  20, *21,  22,  23] <- 24
(  8,   3,   2,   1,   1) [  9,  17, *20,  22,  23,  24] <- 25
(  8,   5,   1,   1,   1) [  9,  17,  22, *23,  24,  25] <- 26
(  8,   5,   2,   1,   1) [  9,  17,  22, *24,  25,  26] <- 27
(  8,   5,   3,   1,   1) [  9,  17,  22,  25, *26,  27] <- 28
(  8,   5,   3,   2,   1) [ *9,  17,  22,  25,  27,  28] <- 29
(  5,   3,   2,   1,   1) [ 17, *22,  25,  27,  28,  29] <- 30
(  8,   2,   1,   1,   1) [ 17,  25, *27,  28,  29,  30] <- 31
(  8,   3,   1,   1,   1) [ 17,  25,  28, *29,  30,  31] <- 32
(  8,   3,   2,   1,   1) [ 17,  25, *28,  30,  31,  32] <- 33
(  8,   5,   1,   1,   1) [ 17,  25,  30, *31,  32,  33] <- 34
(  8,   5,   2,   1,   1) [ 17,  25,  30, *32,  33,  34] <- 35
(  8,   5,   3,   1,   1) [ 17,  25,  30,  33, *34,  35] <- 36
(  8,   5,   3,   2,   1) [*17,  25,  30,  33,  35,  36] <- 37
(  5,   3,   2,   1,   1) [ 25, *30,  33,  35,  36,  37] <- 38
(  8,   2,   1,   1,   1) [ 25,  33, *35,  36,  37,  38] <- 39
(  8,   3,   1,   1,   1) [ 25,  33,  36, *37,  38,  39] <- 40
(  8,   3,   2,   1,   1) [ 25,  33, *36,  38,  39,  40] <- 41
(  8,   5,   1,   1,   1) [ 25,  33,  38, *39,  40,  41] <- 42
(  8,   5,   2,   1,   1) [ 25,  33,  38, *40,  41,  42] <- 43
(  8,   5,   3,   1,   1) [ 25,  33,  38,  41, *42,  43] <- 44
(  8,   5,   3,   2,   1) [*25,  33,  38,  41,  43,  44] <- 45
(  5,   3,   2,   1,   1) [ 33, *38,  41,  43,  44,  45] <- 46
(  8,   2,   1,   1,   1) [ 33,  41, *43,  44,  45,  46] <- 47
(  8,   3,   1,   1,   1) [ 33,  41,  44, *45,  46,  47] <- 48
(  8,   3,   2,   1,   1) [ 33,  41, *44,  46,  47,  48] <- 49
(  8,   5,   1,   1,   1) [ 33,  41,  46, *47,  48,  49] <- 50
=end
