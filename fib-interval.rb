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
      current = floor desc_intervals.first
      j = fibs.index current
      return nil if j == 0

      target = fibs[j-1]
      skipped = nil

      desc_intervals.each_with_index { | x, i |
        y = floor(x)
        next if y == current

        while y < target
          skipped = [target, i]
          j = fibs.index target
          break if j == 0
          target = fibs[j-1]
        end

        current = y

        j = fibs.index y
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

    # puts "intervals = #{intervals.inspect}, desc_part.size = #{desc_part.size}"

    fibs = generate_fibs intervals.length
    fh = FibHelper.new fibs

    fib_i = fh.last_skipped desc_part
    # puts "fib_i = #{fib_i.inspect}"
    return fib_i.last + 1 if fib_i

    if desc_part.size == intervals.size
      # (desc_part.first <= 2) ? 1 : 0
      j = fibs.index fh.floor(desc_part.last)
      if j == 0
        0
      else
        #
      end
    else
      1
    end

    #####
    # prev = nil
    # intervals.each_with_index { | x, i |
    #   if prev
    #     if prev == x
    #       return i if x != 1
    #     elsif prev < x
    #       return i
    #     end
    #   end
    #   prev = x
    # }

    # return 0 if (intervals[-2] == 2) && (intervals[-1] <= 1)
  
    # jprev = nil
    # @fibs.each { | fib |
    #   j = intervals.index(fib)
    #   if jprev
    #     case j
    #     when nil
    #       return 1 + jprev
    #     when 0
    #       return 1
    #     end
    #   end
    #   jprev = j
    # }

    # nil # safety-net
  end
end
