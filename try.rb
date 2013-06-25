#!/usr/bin/env ruby -w

require_relative 'fib-interval'

REX_OPT = /^-([1-9][01-9]*)$/
REX_INT = /^[1-9][01-9]*$/

def usage_then_exit
  puts "Usage: #{$0} n1 [n2] [n3] ..."
  puts "(ex) #{$0} 1 2 3 4 5"
  exit 1
end

def get_intervals(seq)
  result = []
  prev = nil
  seq.each { |x|
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

def show(seq, mark = nil)
  a = seq.dup
  a[mark] = "<#{a[mark]}>" if mark
  delimiter = ' '
  puts "sequence: #{a.join(delimiter)}"
  ivals = get_intervals(seq)
  puts "intervals: (#{ivals.join(delimiter)})"
  totals = get_reverse_accum(ivals)
  puts "reverse accum: (#{totals.join(delimiter)})"
end

usage_then_exit if ARGV.empty?

seq = []
ARGV.each { |s| seq << s.to_i if REX_INT =~ s }
usage_then_exit if seq.empty?
puts "fibs = #{FibInterval.generate_fibs(seq.size).join ' '}"

seq2 = seq.dup
i = FibInterval.index_to_delete get_intervals(seq)
seq2.delete_at i

show(seq, i)
puts '-----'
show(seq2)
