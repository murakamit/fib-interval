class FibInterval
  attr_reader :holding_capacity, :fibs

  HOLDING_CAPACITY_MIN = 4

  def initialize(holding_capacity)
    raise TypeError unless holding_capacity.is_a? Integer
    if holding_capacity < HOLDING_CAPACITY_MIN
      raise "holding_capacity >= #{HOLDING_CAPACITY_MIN}"
    end
    @holding_capacity = holding_capacity
    @holding_capacity.freeze
    @intervals_capacity = holding_capacity - 1
    @intervals_capacity.freeze
    @fibs = generate_fibs(holding_capacity)
    @fibs.freeze
  end

  def indexes_to_delete(intervals)
    raise ArgumentError unless valid_intervals? intervals
    ivals = intervals.dup
    result = []
    # while ivals.size >= @holding_capacity
    #   idx = get_index(ivals)
    #   break if idx.nil?
    #   result << idx
    #   virtual_delete(ivals, idx)
    # end
    result
  end

  alias indices_to_delete indexes_to_delete

  private
  def generate_fibs(n) # [1, 2, 3, 5, 8, 13, 21, ...]
    ary = []
    x,y = 1,1
    n.times { ary << y; x, y = y, x+y }
    ary
  end

  def valid_intervals?(intervals)
    return false unless intervals.is_a? Array
    prev = nil
    intervals.each { |x|
      return false unless x.is_a? Integer
      return false if x < 0
      return false if prev && (prev < x)
      prev = x
    }
    true
  end

  def get_index(intervals)
    return nil if intervals.size < @intervals_capacity

    i = intervals.index(0)
    return i if i

    return 1 if intervals[0] <= 2
    return 0 if (intervals[-2] == 2) && (intervals[-1] <= 1)
  
    jprev = nil
    j0 = nil

    @fibs.each_with_index { | fib, i |
      j = intervals.index(fib)
      if jprev
        case j
        when nil
          return 1 + jprev
        when 0
          return 1
        end
      else
        j0 = j
      end

      jprev = j
    }

    0 # safety-net
  end

  def virtual_delete(ivals, idx)
    if idx > 0
      ivalsa[idx - 1] += ivals[idx]
      ivals.delete_at(idx)
    else
      ivals.shift
    end
  end
end
