# MURAKAMI Teiji
# https://github.com/murakamit/githubtest

module FibInterval
  def self.generate_fibs(length) # [1, 2, 3, 5, 8, 13, 21, ...]
    ary = []
    x,y = 1,1
    length.times { ary << y; x, y = y, x+y }
    ary
  end

  def self.valid_intervals?(intervals)
    return false unless intervals.is_a? Array
    intervals.each { |x|
      return false unless x.is_a? Integer
      return false if x < 0
    }
    true
  end

  def self.index_to_delete(intervals)
    unless valid_intervals? intervals
      raise ArgumentError.new "intervals = [#{intervals.join ', '}]"
    end

    case intervals.size
    when 0
      return nil
    when 1
      return 0
    end

    i = intervals.index(0)
    ( i ) ? i : main(intervals)
  end

  protected

  class FibHelper
    attr_reader :fibs, :rfibs

    def initialize(fibs)
      @fibs = fibs
    end

    def floor(x, fibs = nil)
      return nil if x <= 0
      fibs = @fibs if fibs.nil?
      result = nil
      fibs.each { |f|
        if f == x
          return f
        elsif f < x
          result = f
        else
          break
        end
      }
      result
    end

    def to_floor(intervals, fibs = nil)
      intervals.map { |x| floor(x, fibs) }
    end

    def last_skipped(desc_intervals, fibs = nil)
      fibs = @fibs if fibs.nil?
      floored = to_floor(desc_intervals, fibs)

      current = floored.first
      j = fibs.index current
      return nil if j == 0

      target = fibs[j-1]
      skipped = nil

      floored.each_with_index { | x, i |
        next if x == current

        while x < target
          skipped = [target, i]
          j = fibs.index target
          break if j == 0
          target = fibs[j-1]
        end

        current = x
        j = fibs.index x
        break if j == 0
        target = fibs[j-1]
      }

      skipped
    end
  end # FibHelper

  def self.copy_desc_part(intervals) # 5 4 3 2 2 | 3 3 4 2 1
    prev = nil
    intervals.each_with_index { | x, i |
      return intervals[0 ... i] if prev && (prev < x) # [0, i)
      prev = x
    }
    intervals.dup
  end

  def self.main(intervals)
    desc_part = copy_desc_part intervals
    return 0 if desc_part.size == 1

    fibs = generate_fibs desc_part.length
    fh = FibHelper.new fibs

    fib_i = fh.last_skipped desc_part
    return fib_i.last + 1 if fib_i

    return 1 if intervals.size != desc_part.size

    ( fh.floor(intervals.first) == fibs.last ) ? 0 : 1
  end
end
