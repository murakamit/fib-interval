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

  describe "::copy_desc_part" do
    [
     [ [1],             [1] ],
     [ [3, 2, 1],       [3, 2, 1] ],
     [ [3, 2, 3, 2, 1], [3, 2] ],
     [ [1, 3, 2, 1],    [1] ],
    ].each { | ab |
      a, b = ab
      it { expect(FibInterval.copy_desc_part a).to eq b }
    }
  end

  describe FibInterval::FibHelper do
    let(:fib_len) { 5 }
    let(:fibs) { FibInterval.generate_fibs fib_len }
    subject { FibInterval::FibHelper.new fibs }

    it { expect(fibs).to eq [1, 2, 3, 5, 8] }

    describe "#floor" do
      {
        0 => nil,
        1 => 1,
        2 => 2,
        3 => 3,
        4 => 3,
        5 => 5,
        6 => 5,
        7 => 5,
        8 => 8,
        9 => 8,
        100 => 8, # max(fibs) == 8
      }.each_pair { | x,y |
        it { expect(subject.floor x).to eq y }
      }
    end

    describe "#to_floor" do
      [
       [ [],  [] ],
       [ [1], [1] ],
       [ [1, 1, 1], [1, 1, 1] ],
       [ [2, 1, 1], [2, 1, 1] ],
       [ [2, 2, 2], [2, 2, 2] ],
       [ [3, 2, 1], [3, 2, 1] ],
       [ [4, 2, 1], [3, 2, 1] ],
       [ [5, 2, 1], [5, 2, 1] ],
       [ [5, 3, 1], [5, 3, 1] ],
       [ [9, 8, 7, 6, 5, 4, 3, 2, 1], [8, 8, 5, 5, 5, 3, 3, 2, 1] ],
      ].each { | ab |
        a, b = ab
        it {
          f = fibs
          n = a.size
          f = FibInterval.generate_fibs(n) if n > fib_len
          expect(subject.to_floor(a, f)).to eq b
        }
      }
    end

    describe "#last_skipped" do
      [
       [ [ 8, 5, 3, 2, 1], nil ],
       [ [ 9, 5, 3, 2, 1], nil ],
       [ [ 8, 7, 3, 2, 1], nil ],
       [ [ 8, 5, 3, 2, 2], nil ],
       [ [ 8, 8, 5, 3, 2], nil ],
       [ [13, 8, 5, 3, 2], nil ],
       [ [ 8, 4, 3, 2, 1], [5, 1] ],
       [ [ 8, 5, 3, 1, 1], [2, 3] ],
       [ [ 8, 4, 3, 1, 1], [2, 3] ],
       [ [ 1, 1, 1, 1, 1], nil ],
       [ [ 2, 1, 1, 1, 1], nil ],
       [ [ 3, 1, 1, 1, 1], [2, 1] ],
       [ [ 3, 2, 1, 1, 1], nil ],
       [ [ 5, 1, 1, 1, 1], [2, 1] ],
      ].each { | ab |
        a, b = ab
        it { expect(subject.last_skipped a).to eq b }
      }
    end
  end

  describe "::index_to_delete" do
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
       # [ [5, 1, 1, 1, 1], 2 ],
       # [ [5, 2, 1, 1, 1], 2 ],
       # [ [5, 3, 1, 1, 1], 3 ],
       # [ [5, 3, 2, 1, 1], 1 ],
       # [ [8, 2, 1, 1, 1], 2 ],
       # [ [8, 3, 1, 1, 1], 3 ],
       # [ [8, 3, 2, 1, 1], 2 ],
       # [ [8, 5, 1, 1, 1], 3 ],
       # [ [8, 5, 2, 1, 1], 3 ],
       # [ [8, 5, 3, 1, 1], 4 ],
       # [ [8, 5, 3, 2, 1], 0 ],
      ].each { | ab |
        it {
          pending "after to_floor"
          a, b = ab
          expect(FibInterval.index_to_delete a).to eq b
        }
      }
    end

    context "irregular 0" do
      [
       [ [0, 1, 1, 1, 1], 0],
       [ [1, 0, 1, 1, 1], 1],
       [ [1, 1, 1, 1, 0], 4],
       [ [1, 1, 0, 0, 1], 2],
       [ [2, 0, 1, 0, 1], 1],
      ].each { | ab |
        a, b = ab
        it {
          expect(FibInterval.index_to_delete a).to eq b
        }
      }
    end

    context "contain skipped fib" do
      [
       [ [8, 5, 3, 1, 1], 4 ],
       [ [8, 5, 4, 1, 1], 4 ],
       [ [8, 3, 1, 1, 1], 3 ],
      ].each { | ab |
        a, b = ab
        it {
          expect(FibInterval.index_to_delete a).to eq b
        }
      }
    end

    context "contain asc" do
      [
       [ [1, 3, 2, 1],    0],
       [ [1, 1, 3, 2, 1], 0],
       [ [2, 1, 3, 2, 1], 0],
      ].each { | ab |
        a, b = ab
        it {
          pending "after desc only"
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
