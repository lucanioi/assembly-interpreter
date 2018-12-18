require 'support/comparison_shared_examples'

describe Assembly::Comparison do
  subject(:comparison) { described_class.new(x, y) }
  let(:invalid_values_error) { Assembly::Errors::InvalidValue }

  describe 'initialization' do
    let(:x) { 'x' }
    let(:y) { :y }

    it 'cannot be initialized by non-Integer values' do
      expect { subject }.to raise_error invalid_values_error
    end
  end

  context 'when x is greater than y' do
    let(:x) { 10 }
    let(:y) { 7 }

    it_behaves_like 'x > y'
    it_behaves_like 'x >= y'
    it_behaves_like '!(x == y)'
    it_behaves_like '!(x <= y)'
    it_behaves_like '!(x < y)'
    it_behaves_like 'x != y'
  end

  context 'when x equal to y' do
    let(:x) { 80 }
    let(:y) { 80 }

    it_behaves_like '!(x > y)'
    it_behaves_like 'x >= y'
    it_behaves_like 'x == y'
    it_behaves_like 'x <= y'
    it_behaves_like '!(x < y)'
    it_behaves_like '!(x != y)'
  end

  context 'when x is less than y' do
    let(:x) { 1 }
    let(:y) { 99 }

    it_behaves_like '!(x > y)'
    it_behaves_like '!(x >= y)'
    it_behaves_like '!(x == y)'
    it_behaves_like 'x <= y'
    it_behaves_like 'x < y'
    it_behaves_like 'x != y'
  end
end

