describe Assembly::Registry do
  let(:register) { described_class.new }
  let(:invalid_register_error) { Assembly::Errors::InvalidRegister }
  let(:empty_register_error) { Assembly::Errors::EmptyRegister }

  describe '#insert' do
    it 'inserts the value at the given register' do
      register.insert(10, at: :b)

      expect(register.read(:b)).to eq 10
    end

    context 'when given register doesn\'t exist' do
      it 'throws an invalid register error' do
        invalid_insert = proc { register.insert(20, at: :invalid) }

        expect(&invalid_insert).to raise_error invalid_register_error
      end
    end
  end

  describe '#read' do
    it 'retrieves the value at the given register' do
      register.insert(10, at: :b)

      expect(register.read(:b)).to eq 10
    end

    context 'when the given register doesn\'t exist' do
      it 'throws an invalid register error' do
        invalid_read = proc { register.read(:invalid) }

        expect(&invalid_read).to raise_error invalid_register_error
      end
    end

    context 'when there the register is empty' do
      it 'throws an empty register error' do
        empty_read = proc { register.read(:g) }

        expect(&empty_read).to raise_error empty_register_error
      end
    end
  end
end
