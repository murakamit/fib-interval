#!/usr/bin/env ruby -w

# MURAKAMI Teiji
# https://github.com/murakamit/githubtest

begin
  require_relative 'fib-interval'
rescue
  require 'fib-interval'
end

REX_INT = /^[1-9][01-9]*$/

def usage_then_exit
  puts "Usage: #{$0} n1 [n2] [n3] ..."
  puts "(ex) #{$0} 1 2 3 4 5"
  exit 1
end

def get_intervals(list)
  result = []
  prev = nil
  list.each { |x|
    result << (x - prev) if prev
    prev = x
  }
  result
end

def get_reverse_accum(ivals)
  result = []
  accum = 0
  ivals.reverse.each { |x|
    accum += x
    result << accum
  }
  result.reverse
end

def show(list, mark = nil)
  a = list.dup
  a[mark] = "*#{a[mark]}" if mark
  delimiter = ' '
  puts "list: #{a.join(delimiter)}"
  ivals = get_intervals(list)
  puts "intervals: (#{ivals.join(delimiter)})"
  totals = get_reverse_accum(ivals)
  puts "reverse accum: (#{totals.join(delimiter)})"
end

usage_then_exit if ARGV.empty?

list = []
ARGV.each { |s| list << s.to_i if REX_INT =~ s }
usage_then_exit if list.empty?
puts "fibs = #{FibInterval.generate_fibs(list.size).join ' '}"

list2 = list.dup
i = FibInterval.index_to_delete get_intervals(list)
list2.delete_at i if i

show(list, i)
puts '-----'
show(list2)
