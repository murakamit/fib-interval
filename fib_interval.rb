class FibInterval
  attr_reader :capacity, :fib

  CAPACITY_MIN = 4

  def initialize(capacity)
    if capacity.is_a? Integer
      if capacity < CAPACITY_MIN
        raise "'capacity' is required at least #{CAPACITY_MIN}"
      end
      @capacity = capacity
      @capacity.freeze
      @fib = generate_fib(capacity)
      @fib.freeze
    else
      raise "argument class error"
    end
  end

  private
  def generate_fib(n) # [1, 2, 3, 5, 8, 13, 21, ...]
    ary = []
    x,y = 1,1
    n.times { ary << y; x, y = y, x+y }
    ary
  end
end
