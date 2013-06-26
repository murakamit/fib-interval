#!/usr/bin/env ruby -w

require_relative '../fib-interval'
require 'fileutils'

KEEP_MAX = 6

# backup-yyyy-mmdd-hhmmss
REX_FILENAME = /^backup-(\d{4})-(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})$/i

$list = []

def filename2counter(s)
  m = REX_FILENAME.match s
  m ? m[1 .. 3].join.to_i : nil # use ymd, ignore hms
end

def listup
  $list = []
  Dir.foreach('.') { |s|
    m = REX_FILENAME.match s
    next unless m
    $list << [s, filename2counter(s)]
  }
end

def get_intervals
  result = []
  prev = nil
  $list.each { |a|
    x = a.last
    result << (x - prev) if prev
    prev = x
  }
  result
end

def main(t)
  listup

  while $list.size >= KEEP_MAX
    i = FibInterval.index_to_delete get_intervals
    raise unless i
    s = $list[i].first
    puts "delete '#{s}'"
    File.delete s
    listup
  end

  s = t.strftime "%Y-%m%d-%H%M%S"
  s = "backup-#{s}"
  puts "touch '#{s}'"
  FileUtils.touch s
end

ymd = ARGV[0 .. 2]
ymd.map! { |s|
  x = s.to_i
  (x > 0) ? x : nil
}
t = ymd.first ? Time.new(*ymd) : Time.now
main t


### result ###
=begin
$ ruby 01_daily-backup.rb 1 1 1
touch 'backup-0001-0101-000000'
$ ls backup-*
backup-0001-0101-000000
$ ruby 01_daily-backup.rb 1 1 2
touch 'backup-0001-0102-000000'
$ ls backup-*
backup-0001-0101-000000		backup-0001-0102-000000
$ ruby 01_daily-backup.rb 1 1 3
touch 'backup-0001-0103-000000'
$ ls backup-*
backup-0001-0101-000000		backup-0001-0103-000000
backup-0001-0102-000000
      :
      :
$ ruby 01_daily-backup.rb 1 1 6
touch 'backup-0001-0106-000000'
$ ls backup-*
backup-0001-0101-000000		backup-0001-0104-000000
backup-0001-0102-000000		backup-0001-0105-000000
backup-0001-0103-000000		backup-0001-0106-000000
$ ruby 01_daily-backup.rb 1 1 7
delete 'backup-0001-0102-000000'
touch 'backup-0001-0107-000000'
$ ls backup-*
backup-0001-0101-000000		backup-0001-0105-000000
backup-0001-0103-000000		backup-0001-0106-000000
backup-0001-0104-000000		backup-0001-0107-000000
$ ruby 01_daily-backup.rb 1 1 8
delete 'backup-0001-0103-000000'
touch 'backup-0001-0108-000000'
$ ls backup-*
backup-0001-0101-000000		backup-0001-0106-000000
backup-0001-0104-000000		backup-0001-0107-000000
backup-0001-0105-000000		backup-0001-0108-000000
=end
