describe Assembly::Registry do
  let(:register) { described_class.new }
  let(:invalid_register_error) { Assembly::Errors::InvalidRegister }
  let(:empty_register_error) { Assembly::Errors::EmptyRegister }

  describe '#insert' do
    it 'inserts the value at the given register' do
      subject.insert(10, at: :b)

      expect(subject.read(:b)).to eq 10
    end

    context 'when given register doesn\'t exist' do
      it 'throws an invalid register error' do
        invalid_insert = proc { subject.insert(20, at: :invalid) }

        expect(&invalid_insert).to raise_error invalid_register_error
      end
    end
  end

  describe '#read' do
    it 'retrieves the value at the given register' do
      subject.insert(10, at: :b)

      expect(subject.read(:b)).to eq 10
    end

    context 'when the given register doesn\'t exist' do
      it 'throws an invalid register error' do
        invalid_read = proc { subject.read(:invalid) }

        expect(&invalid_read).to raise_error invalid_register_error
      end
    end

    context 'when there the register is empty' do
      it 'throws an empty register error' do
        empty_read = proc { subject.read(:g) }

        expect(&empty_read).to raise_error empty_register_error
      end
    end
  end
end
