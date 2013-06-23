class FibInterval
  attr_reader :capacity, :fib

  CAPACITY_MIN = 4

  def initialize(capacity)
    raise TypeError unless capacity.is_a? Integer
    raise "'capacity' >= #{CAPACITY_MIN}" unless capacity >= CAPACITY_MIN
    @capacity = capacity
    @capacity.freeze
    @fib = generate_fib(capacity)
    @fib.freeze
  end

  def indexes_to_delete(ary)
    raise ArgumentError unless valid_ary? ary
    result = []
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
end
