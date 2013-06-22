class FibInterval
  attr_reader :size, :fib

  SIZE_MIN = 4

  def initialize(size)
    if size.is_a? Integer
      raise "'size' required at least #{SIZE_MIN}" if size < SIZE_MIN
      @size = size
      @size.freeze
      @fib = generate_fib(size)
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
