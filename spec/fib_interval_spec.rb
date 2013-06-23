require_relative '../fib_interval'

describe FibInterval do
  context "when constructing" do
    describe do
      it { expect(FibInterval::CAPACITY_MIN).to be >= 4 }
    end

    describe "#new" do
      it { expect { FibInterval.new }.to raise_error }

      [FibInterval::CAPACITY_MIN, 10, 20].each { |x|
        it { expect { FibInterval.new(x) }.not_to raise_error }
      }

      [nil, -1, 0, 1, 10.0, '10'].each { |x|
        it { expect { FibInterval.new(x) }.to raise_error }
      }
    end
  end

  context "when constructed (capacity = 6)" do
    let(:arg_capacity) { 6 }
    subject { FibInterval.new(arg_capacity) }

    describe "#capacity" do
      it { expect(subject.capacity).to eq arg_capacity }
    end

    describe "#fib" do
      let(:fib) { subject.fib }
      it { expect(fib).to be_a_kind_of Array }
      it { expect(fib.size).to be >= subject.capacity }
      it { expect(fib).to start_with(1,2) }
      it {
        expect {
          result = true
          a,b = 1,2
          fib[2 .. -1].each { |x|
            if (a+b) == x
              a,b = b,x
            else
              result = false
              break
            end
          }
          result
        }.to be_true
      }
    end

    describe "#indexes_to_delete ok/ng" do
      [nil, "", 0, %w(1 1 1)].each { |x|
        it { expect { subject.indexes_to_delete(x) }.to raise_error }
      }

      [ [-1], [0.0], [0, 1], [1, 0, 1], [1, 2, 3] ].each { |x|
        it { expect { subject.indexes_to_delete(x) }.to raise_error }
      }

      [ [], [0], [0, 0], [1], [1, 1], [1, 1, 0], [3, 2, 1] ].each { |x|
        it { expect { subject.indexes_to_delete(x) }.not_to raise_error }
      }

      [0, 1, 2].each { |x|
        it {
          n = subject.capacity + x
          a = Array.new(n, 0)
          expect { subject.indexes_to_delete(a) }.not_to raise_error
        }
      }
    end

    describe "#indexes_to_delete example" do
      context "ary.size < arg_capacity" do
        let(:ret) { subject.indexes_to_delete [] }
        it { expect(ret).to be_a_kind_of Array }
        it { expect(ret).to be_empty }
      end

      context "ary.size == arg_capacity" do
        # [0, 1].each { | val |
        #   it {
        #     ary = Array.new(arg_capacity, val)
        #     x = subject.indexes_to_delete ary
        #     expect(x).to eq ary[1 .. -1]
        #   }
        # }
      end

      context "ary.size > arg_capacity" do
      end
    end
  end
end
