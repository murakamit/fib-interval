#!/usr/bin/env ruby -w

require_relative '../fib-interval'
require 'fileutils'

KEEP_MAX = 6
DAY1 = 60 * 60 * 24

# backup-yyyy-mmdd-hhmmss
REX_FILENAME = /^backup-(\d{4})-(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})$/i

$list = []

def filename2counter(s)
  m = REX_FILENAME.match s
  return nil unless m
  Time.new(*m[1 .. 3]).to_i / DAY1
end

def update_list
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

def delete_overflow
  while $list.size >= KEEP_MAX
    i = FibInterval.index_to_delete get_intervals
    raise unless i
    s = $list[i].first
    puts "delete '#{s}'"
    File.delete s
    update_list
  end
end

def backup(t)
  s = t.strftime "%Y-%m%d-%H%M%S"
  s = "backup-#{s}"
  puts "touch '#{s}'"
  FileUtils.touch s
end

def main(t)
  update_list
  delete_overflow
  backup(t)
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
$ ruby 01_daily-backup.rb 2000 1 1
touch 'backup-2000-0101-000000'
$ ruby 01_daily-backup.rb 2000 1 2
touch 'backup-2000-0102-000000'
$ ruby 01_daily-backup.rb 2000 1 3
touch 'backup-2000-0103-000000'
$ ruby 01_daily-backup.rb 2000 1 4
touch 'backup-2000-0104-000000'
$ ruby 01_daily-backup.rb 2000 1 5
touch 'backup-2000-0105-000000'
$ ruby 01_daily-backup.rb 2000 1 6
touch 'backup-2000-0106-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0104-000000
backup-2000-0102-000000		backup-2000-0105-000000
backup-2000-0103-000000		backup-2000-0106-000000
$ ruby 01_daily-backup.rb 2000 1 7
delete 'backup-2000-0102-000000'
touch 'backup-2000-0107-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0105-000000
backup-2000-0103-000000		backup-2000-0106-000000
backup-2000-0104-000000		backup-2000-0107-000000
$ ruby 01_daily-backup.rb 2000 1 8
delete 'backup-2000-0103-000000'
touch 'backup-2000-0108-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0106-000000
backup-2000-0104-000000		backup-2000-0107-000000
backup-2000-0105-000000		backup-2000-0108-000000
$ ruby 01_daily-backup.rb 2000 1 9
delete 'backup-2000-0105-000000'
touch 'backup-2000-0109-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0107-000000
backup-2000-0104-000000		backup-2000-0108-000000
backup-2000-0106-000000		backup-2000-0109-000000
$ ruby 01_daily-backup.rb 2000 1 10
delete 'backup-2000-0104-000000'
touch 'backup-2000-0110-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0108-000000
backup-2000-0106-000000		backup-2000-0109-000000
backup-2000-0107-000000		backup-2000-0110-000000
$ ruby 01_daily-backup.rb 2000 1 11
delete 'backup-2000-0107-000000'
touch 'backup-2000-0111-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0109-000000
backup-2000-0106-000000		backup-2000-0110-000000
backup-2000-0108-000000		backup-2000-0111-000000
$ ruby 01_daily-backup.rb 2000 1 12
delete 'backup-2000-0108-000000'
touch 'backup-2000-0112-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0110-000000
backup-2000-0106-000000		backup-2000-0111-000000
backup-2000-0109-000000		backup-2000-0112-000000
$ ruby 01_daily-backup.rb 2000 1 13
delete 'backup-2000-0110-000000'
touch 'backup-2000-0113-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0111-000000
backup-2000-0106-000000		backup-2000-0112-000000
backup-2000-0109-000000		backup-2000-0113-000000
$ ruby 01_daily-backup.rb 2000 1 14
delete 'backup-2000-0106-000000'
touch 'backup-2000-0114-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0112-000000
backup-2000-0109-000000		backup-2000-0113-000000
backup-2000-0111-000000		backup-2000-0114-000000
$ ruby 01_daily-backup.rb 2000 1 15
delete 'backup-2000-0111-000000'
touch 'backup-2000-0115-000000'
$ ls backup-*
backup-2000-0101-000000		backup-2000-0113-000000
backup-2000-0109-000000		backup-2000-0114-000000
backup-2000-0112-000000		backup-2000-0115-000000
=end
