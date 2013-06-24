class FibInterval
  attr_reader :holding_capacity, :fibs

  HOLDING_CAPACITY_MIN = 4

  def initialize(holding_capacity)
    unless holding_capacity.is_a? Integer
      raise TypeError.new("holding_capacity.class = #{holding_capacity.class}")
    end
    if holding_capacity < HOLDING_CAPACITY_MIN
      raise ArgumentError.new("holding_capacity >= #{HOLDING_CAPACITY_MIN}")
    end
    @holding_capacity = holding_capacity
    @holding_capacity.freeze
    @intervals_capacity = holding_capacity - 1
    @intervals_capacity.freeze
    @fibs = generate_fibs(@intervals_capacity)
    @fibs.freeze
  end

  def indexes_to_delete(intervals)
    unless valid_intervals? intervals
      raise ArgumentError.new("intervals = [#{intervals.join ', '}]")
    end
    ivals = intervals.dup
    result = []
    while ivals.size >= @intervals_capacity
      idx = get_index(ivals)
      break if idx.nil?
      result << idx
      virtual_delete(ivals, idx)
    end
    result
  end

  alias indices_to_delete indexes_to_delete

  private
  def generate_fibs(length) # [1, 2, 3, 5, 8, 13, 21, ...]
    ary = []
    x,y = 1,1
    length.times { ary << y; x, y = y, x+y }
    ary
  end

  def valid_intervals?(intervals)
    return false unless intervals.is_a? Array
    intervals.each { |x|
      return false unless x.is_a? Integer
      return false if x < 0
    }
    true
  end

  def get_index(intervals)
    return nil if intervals.size < @intervals_capacity

    j = intervals.index(0)
    return j if j

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

  def virtual_delete(ivals, idx)
    if idx > 0
      ivals[idx - 1] += ivals[idx]
      ivals.delete_at(idx)
      # ivals[idx] = nil
    else
      ivals.shift
    end
  end
end
