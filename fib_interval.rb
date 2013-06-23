class FibInterval
  attr_reader :holding_capacity, :fib

  HOLDING_CAPACITY_MIN = 4

  def initialize(holding_capacity)
    raise TypeError unless holding_capacity.is_a? Integer
    if holding_capacity < HOLDING_CAPACITY_MIN
      raise "holding_capacity >= #{HOLDING_CAPACITY_MIN}"
    end
    @holding_capacity = holding_capacity
    @holding_capacity.freeze
    @interval_capacity = holding_capacity - 1
    @interval_capacity.freeze
    @fib = generate_fib(holding_capacity)
    @fib.freeze
  end

  def indexes_to_delete(ary)
    raise ArgumentError unless valid_ary? ary
    a = ary.dup
    result = []
    # while a.size >= @holding_capacity
    #   idx = get_index(a)
    #   break if idx.nil?
    #   result << idx
    #   virtual_delete(a, idx)
    # end
    result
  end

  alias indices_to_delete indexes_to_delete

  private
  def generate_fib(n) # [1, 2, 3, 5, 8, 13, 21, ...]
    ary = []
    x,y = 1,1
    n.times { ary << y; x, y = y, x+y }
    ary
  end

  def valid_ary?(ary)
    return false unless ary.is_a? Array
    prev = nil
    ary.each { |x|
      return false unless x.is_a? Integer
      return false if x < 0
      return false if prev && (prev < x)
      prev = x
    }
    true
  end

  def get_index(ary)
    return nil if ary.size < @holding_capacity
  end

  def virtual_delete(result, idx)
  end
end
