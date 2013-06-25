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
      @rfibs = fibs.reverse
    end

    def floor(x)
      result = nil
      @fibs.each { |f|
        break if f > x
        result = f
      }
      result
    end

    def last_skipped(intervals)
      result = nil
      intervals.each_with_index { | x,i |
        f = floor(x)
        break if f.nil?
        result = [f, i]
      }
      result
    end
  end

  def desc_part(intervals) # 5 4 3 2 2 | 3 3 4 2 1
    prev = nil
    intervals.each_with_index { | x, i |
      return intervals[0 ... i] if prev && (prev < x) # [0, i)
      prev = x
    }
    intervals
  end

  def self.main(intervals)
    original = intervals
    fibs = generate_fibs original.length
    # intervals = desc_part intervals


    # ignore_last = intervals[0 .. -2]
    # ignore_last.each_with_index { | x, i |
    #   return i + 1 if x < rfibs[i]
    # }

    # 0


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
