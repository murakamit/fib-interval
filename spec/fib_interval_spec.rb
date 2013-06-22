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

  context "constructed successfully" do
    let(:n) { 10 }
    subject { FibInterval.new(n) }

    describe "#capacity" do
      it { expect(subject.capacity).to eq n }
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

    # describe "#index_to_delete" do
    #   it { expect(subject.index_to_delete(nil)).to raise_error }
    # end
  end
end
