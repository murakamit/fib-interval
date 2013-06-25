require_relative '../fib-interval'

describe FibInterval do
  describe do
    it { expect(FibInterval::HOLDING_CAPACITY_MIN).to be >= 4 }
  end

  describe "::generate_fibs" do
    let(:fibs) { FibInterval.generate_fibs 5 }
    it { expect(fibs).to be_a_kind_of Array }
    it { expect(fibs).to start_with(1,2) }
    it "[1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, ...]" do
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
    end
  end

  describe "::valid_intervals?" do
    context do
      [nil, "", 0, %w(1 1 1), [0.0], [-1] ].each { |x|
        it { expect(FibInterval.valid_intervals? x).to be_false }
      }
    end

    context do
      [
       [], [0], [0, 0], [1], [1, 1], [1, 1, 0], [0, 1, 1],
       [1, 2, 3], [3, 2, 1], [1, 0, 2], [2, 1, 2],
      ].each { |a|
        it { expect(FibInterval.valid_intervals? a).to be_true }
      }
    end
  end

  describe "#new" do
    context "no arg" do
      it { expect { FibInterval.new }.to raise_error }
    end

    context do
      [nil, -1, 0, 1, 10.0, '10'].each { |n|
        it { expect { FibInterval.new n }.to raise_error }
      }
    end

    context do
      [FibInterval::HOLDING_CAPACITY_MIN, 10, 20].each { |n|
        it { expect { FibInterval.new n }.not_to raise_error }
      }
    end
  end

  context "when constructed (holding_capacity = 6)" do
    let(:holding_capacity) { 6 }
    subject { FibInterval.new holding_capacity }

    describe "#holding_capacity" do
      it { expect(subject.holding_capacity).to eq holding_capacity }
    end

    describe "#index_to_delete don't destroy arg" do
      [0, 1, 2, 3, 10, 100].each { |n|
        it do
          intervals = Array.new(n, 1)
          intervals.freeze
          expect { subject.index_to_delete intervals }.not_to raise_error
          expect(intervals.size).to eq n
        end
      }
    end

    describe "#index_to_delete example" do
      context "intervals.size < holding_capacity" do
        it { expect(subject.index_to_delete []).to be_nil }
      end

      context "intervals.size == holding_capacity" do
        # holding_capacity   == 6
        # intervals_capacity == 5
        [
         [ [0, 0, 0, 0, 0], 0 ],
         [ [1, 1, 1, 1, 1], 1 ],
         [ [2, 1, 1, 1, 1], 1 ],
         [ [3, 1, 1, 1, 1], 2 ],
         [ [3, 2, 1, 1, 1], 1 ],
         [ [5, 1, 1, 1, 1], 2 ],
         [ [5, 2, 1, 1, 1], 2 ],
         [ [5, 3, 1, 1, 1], 3 ],
         [ [5, 3, 2, 1, 1], 1 ],
         [ [8, 2, 1, 1, 1], 2 ],
         [ [8, 3, 1, 1, 1], 3 ],
         [ [8, 3, 2, 1, 1], 2 ],
         [ [8, 5, 1, 1, 1], 3 ],
         [ [8, 5, 2, 1, 1], 3 ],
         [ [8, 5, 3, 1, 1], 4 ],
         [ [8, 5, 3, 2, 1], 0 ],
        ].each { | ab |
          it {
            pending "before branch"
            a, b = ab
            expect(subject.index_to_delete a).to eq b
          }
        }
      end

      context "intervals.size > holding_capacity" do
        # holding_capacity   == 6
        # intervals_capacity == 5
        let(:valid_full_intervals) { [8, 5, 3, 2, 1] }
        let(:delta) { 10 }

        it {
          pending "before branch"
          ary0 = Array.new(delta, 0)
          intervals2 = valid_full_intervals + ary0
          i = subject.index_to_delete intervals2
          expect(i).to eq valid_full_intervals.size
        }

        it {
          pending "fibs must generate dynamically?"
          ary1 = Array.new(delta, 1)
          intervals2 = valid_full_intervals + ary1
          i = subject.index_to_delete intervals2
          # expect(i).to eq valid_full_intervals.size
        }
      end

      context "when intervals contain irregular 0" do
        # holding_capacity   == 6
        # intervals_capacity == 5
        [
         [0, 1, 1, 1, 1],
         [1, 0, 1, 1, 1],
         [1, 1, 1, 1, 0],
         [1, 1, 0, 0, 1],
         [2, 0, 1, 0, 1],
        ].each { | intervals |
          it {
            pending "before branch"
            expect { subject.index_to_delete intervals }.not_to raise_error
          }
        }
      end

      context "when intervals contain non-fib" do
        # holding_capacity   == 6
        # intervals_capacity == 5
        [
         [ [8, 5, 4, 1, 1], 2 ],
        ].each { | ab |
          a, b = ab
          it {
            pending "before branch"
            expect(subject.index_to_delete a).to eq b
          }
        }
      end
    end
  end
end
