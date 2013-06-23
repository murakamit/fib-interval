require_relative '../fib-interval'

describe FibInterval do
  context "when constructing" do
    describe do
      it { expect(FibInterval::HOLDING_CAPACITY_MIN).to be >= 4 }
    end

    describe "#new" do
      it { expect { FibInterval.new }.to raise_error }

      [FibInterval::HOLDING_CAPACITY_MIN, 10, 20].each { |n|
        it { expect { FibInterval.new(n) }.not_to raise_error }
      }

      [nil, -1, 0, 1, 10.0, '10'].each { |n|
        it { expect { FibInterval.new(n) }.to raise_error }
      }
    end
  end

  context "when constructed (holding_capacity = 6)" do
    let(:holding_capacity) { 6 }
    subject { FibInterval.new(holding_capacity) }

    describe "#holding_capacity" do
      it { expect(subject.holding_capacity).to eq holding_capacity }
    end

    describe "#fibs" do
      let(:fibs) { subject.fibs }
      it { expect(fibs).to be_a_kind_of Array }
      it { expect(fibs.size).to be >= subject.holding_capacity }
      it { expect(fibs).to start_with(1,2) }
      it {
        expect {
          result = true
          a,b = 1,2
          fibs[2 .. -1].each { |x|
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

    describe "#indexes_to_delete" do
      [ [], [0], [0, 0], [1], [1, 1], [1, 1, 0], [3, 2, 1] ].each { | intervals |
        it {
          expect { subject.indexes_to_delete(intervals) }.not_to raise_error
        }
      }
    end

    context "when #indexes_to_delete receive Not-a-Positive-Integer Array" do
      [nil, "", 0, %w(1 1 1), [0.0], [-1] ].each { |x|
        it { expect { subject.indexes_to_delete(x) }.to raise_error }
      }
    end

    context "when #indexes_to_delete receive ascending intervals" do
      [ [1, 2, 3], [1, 0, 2], [2, 1, 2] ].each { | intervals |
        it { expect { subject.indexes_to_delete(intervals) }.to raise_error }
      }
    end

    context "when #indexes_to_delete receive overflow intervals" do
      [0, 1, 2].each { | delta |
        it {
          n = subject.holding_capacity + delta
          intervals = Array.new(n, 1)
          expect { subject.indexes_to_delete(intervals) }.not_to raise_error
        }
      }
    end

    describe "#indexes_to_delete don't destroy arg" do
      [0, 1, 2, 3, 10, 100].each { |n|
        it {
          intervals = Array.new(n, 1)
          intervals.freeze
          expect { subject.indexes_to_delete intervals }.not_to raise_error
          expect(intervals.size).to eq n
        }
      }
    end

    describe "#indexes_to_delete example" do
      context "intervals.size < holding_capacity" do
        let(:ret) { subject.indexes_to_delete [] }
        it { expect(ret).to be_a_kind_of Array }
        it { expect(ret).to be_empty }
      end

      context "intervals.size == holding_capacity" do
        # holding_capacity   == 6
        # intervals_capacity == 5
        [
         [ [0, 0, 0, 0, 0], [0] ],
         [ [1, 1, 1, 1, 1], [1] ],
         [ [2, 1, 1, 1, 1], [1] ],
         [ [3, 1, 1, 1, 1], [2] ],
         [ [3, 2, 1, 1, 1], [1] ],
         [ [5, 1, 1, 1, 1], [2] ],
         [ [5, 2, 1, 1, 1], [2] ],
         [ [5, 3, 1, 1, 1], [3] ],
         [ [5, 3, 2, 1, 1], [1] ],
         [ [8, 2, 1, 1, 1], [2] ],
         [ [8, 3, 1, 1, 1], [3] ],
         [ [8, 3, 2, 1, 1], [2] ],
         [ [8, 5, 1, 1, 1], [3] ],
         [ [8, 5, 2, 1, 1], [3] ],
         [ [8, 5, 3, 1, 1], [4] ],
         [ [8, 5, 3, 2, 1], [0] ],
        ].each { | ab |
          it {
            a, b = ab
            x = subject.indexes_to_delete a
            expect(x).to eq b
          }
        }
      end

      context "intervals.size > holding_capacity" do
        # holding_capacity   == 6
        # intervals_capacity == 5
      end

      context "when intervals contain irregular 0" do
        [
         [1, 0, 1],
         [1, 0, 0, 1],
         [1, 0, 1, 0],
         [2, 0, 1, 0],
        ].each { | intervals |
          it { expect { subject.indexes_to_delete intervals }.not_to raise_error }
        }
      end
    end
  end
end
