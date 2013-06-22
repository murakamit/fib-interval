require_relative '../fib_interval'

describe FibInterval do
  context "when constructing" do
    describe do
      it { expect(FibInterval::SIZE_MIN).to be >= 4 }
    end

    describe "#new" do
      it { expect { FibInterval.new }.to raise_error }
      it { expect { FibInterval.new(10) }.not_to raise_error }
      it { expect { FibInterval.new(FibInterval::SIZE_MIN) }.not_to raise_error }

      it { expect { FibInterval.new(nil) }.to raise_error }
      it { expect { FibInterval.new('10') }.to raise_error }
      it { expect { FibInterval.new(-1) }.to raise_error }
      it { expect { FibInterval.new(0) }.to raise_error }
      it { expect { FibInterval.new(1) }.to raise_error }
    end
  end

  context "constructed successfully" do
    let(:n) { 10 }
    subject { FibInterval.new(n) }

    describe "#size" do
      it { expect(subject.size).to eq n }
    end

    describe "#fib" do
      let(:fib) { subject.fib }
      it { expect(fib).to be_a_kind_of Array }
      it { expect(fib.size).to be >= subject.size }
      it { expect(fib.first 2).to eq [1,2] }
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
  end
end
