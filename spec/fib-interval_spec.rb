require_relative '../fib-interval'

describe FibInterval do
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

  describe FibInterval::FibHelper do
    let(:fib_len) { 5 }
    let(:fibs) { FibInterval.generate_fibs fib_len }
    subject {
      class Spy < FibInterval::FibHelper
        def initialize(x);  super x; end
        def floor(x); super x; end
        def last_skipped(x) super x; end
      end
      Spy.new fibs
    }

    it { expect(fibs).to eq [1, 2, 3, 5, 8] }

    { 3 => 3, 4 => 3, 5 => 5 }.each_pair { | x,y |
      it { expect(subject.floor x).to eq y }
    }

    [
     [ [8, 5, 3, 2, 1], nil ]
    ].each { | ab |
      a, b = ab
      it { expect(subject.last_skipped a).to eq b }
    }
  end

  describe "#index_to_delete" do
    describe "don't destroy arg" do
      [0, 1, 2, 3, 10, 100].each { |n|
        it do
          intervals = Array.new(n, 1)
          intervals.freeze
          expect { FibInterval.index_to_delete intervals }.not_to raise_error
          expect(intervals.size).to eq n
        end
      }
    end

    context "empty ary"  do
      it { expect(FibInterval.index_to_delete []).to be_nil }
    end

    describe do
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
          expect(FibInterval.index_to_delete a).to eq b
        }
      }
    end

    context "irregular 0" do
      [
       [0, 1, 1, 1, 1],
       [1, 0, 1, 1, 1],
       [1, 1, 1, 1, 0],
       [1, 1, 0, 0, 1],
       [2, 0, 1, 0, 1],
      ].each { | intervals |
        it {
          pending "before branch"
          expect { FibInterval.index_to_delete intervals }.not_to raise_error
        }
      }
    end

    context "non-fib" do
      [
       [ [8, 5, 4, 1, 1], 2 ],
      ].each { | ab |
        a, b = ab
        it {
          pending "before branch"
          expect(FibInterval.index_to_delete a).to eq b
        }
      }
    end

    describe do
      let(:valid_intervals) { [8, 5, 3, 2, 1] }
      let(:delta) { 10 }

      it {
        pending "before branch"
        ary0 = Array.new(delta, 0)
        intervals2 = valid_full_intervals + ary0
        i = FibInterval.index_to_delete intervals2
        expect(i).to eq valid_full_intervals.size
      }

      it {
        pending "fibs must generate dynamically?"
        ary1 = Array.new(delta, 1)
        intervals2 = valid_full_intervals + ary1
        i = FibInterval.index_to_delete intervals2
        # expect(i).to eq valid_full_intervals.size
      }
    end
  end
end
