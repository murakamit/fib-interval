class FibInterval
  attr_reader :holding_capacity, :fibs

  HOLDING_CAPACITY_MIN = 4

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

  def initialize(holding_capacity)
    unless holding_capacity.is_a? Integer
      raise TypeError.new "holding_capacity.class = #{holding_capacity.class}"
    end
    if holding_capacity < HOLDING_CAPACITY_MIN
      raise ArgumentError.new "holding_capacity >= #{HOLDING_CAPACITY_MIN}"
    end
    @holding_capacity = holding_capacity
    @holding_capacity.freeze
    @intervals_capacity = holding_capacity - 1
    @intervals_capacity.freeze
  end

  def index_to_delete(intervals)
    if self.class.valid_intervals? intervals
      get_index(intervals)
    else
      raise ArgumentError.new "intervals = [#{intervals.join ', '}]"
    end
  end

  private
  def search_partial_fib_max(intervals, fibs)
    result = nil
    intervals.reverse.each_with_index { | x, i |
      next if x < 2
      break unless fibs.include? x
      break if result && (x <= result.first)
      result = [x, i]
    }
    result[1] = intervals.size + result[1] if result # adjust negative index
    result
  end

  def get_index(intervals)
    return nil if intervals.size < @intervals_capacity

    j = intervals.index(0)
    return j if j

    fibs = self.class.generate_fibs intervals.length
    partial_fib_max = search_partial_fib_max(intervals, fibs)

#next


    return 1 if intervals[0] <= 2

    intervals.each_with_index { | x, i |
      return i unless @fibs.include? x
    }

    prev = nil
    intervals.each_with_index { | x, i |
      if prev
        if prev == x
          return i if x != 1
        elsif prev < x
          return i
        end
      end
      prev = x
    }

    return 0 if (intervals[-2] == 2) && (intervals[-1] <= 1)
  
    jprev = nil
    @fibs.each { | fib |
      j = intervals.index(fib)
      if jprev
        case j
        when nil
          return 1 + jprev
        when 0
          return 1
        end
      end
      jprev = j
    }

    nil # safety-net
  end
end
