require_relative '../fib_interval'

describe FibInterval do
  context "construct with/without arg" do
    describe "#new" do
      it { expect { FibInterval.new }.to raise_error }
      it { expect { FibInterval.new(10) }.not_to raise_error }
    end
  end

  context "constructed successfully" do
    let(:n) { 10 }
    subject { FibInterval.new(n) }

    describe "#size" do
      it { expect(subject.size).to eq(n) }
    end

    describe "#fib" do
      let(:x) { subject.fib }
      it { expect(x).to be_a_kind_of(Array) }
    end
  end
end
