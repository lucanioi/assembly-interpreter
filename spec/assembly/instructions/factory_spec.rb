describe Assembly::Instructions::Factory do
  subject(:instruction_factory) { described_module }
  let(:create_instruction) { subject.create(raw_instruction) }
  let(:created_instruction) { create_instruction }
  let(:invalid_instruction_error) { Assembly::Errors::InvalidInstruction }

  describe '#create' do
    context 'given a valid instruction name' do
      let(:raw_instruction) { 'mov   c, 4' }

      it 'creates an instance of the given instruction' do
        expect(created_instruction).to be_an_instance_of Assembly::Instructions::Mov
      end

      it 'creates the instance with the correct attributes' do
        expect(created_instruction).to eq Assembly::Instructions::Mov.new(:c, 4)
      end

      context 'when given strings as well as registers' do
        let(:raw_instruction) { "msg   'mod(', a, ', ', b, ') = ', d" }

        it 'can identify string arguments ' do
          expect(created_instruction).to eq Assembly::Instructions::Msg.new('mod(', :a, ', ', :b, ') = ', :d)
        end
      end

      context 'when given varied number of spaces' do
        let(:raw_instruction) { "msg   'mod(', a,    ', ',b, ') = ', d" }

        it 'splits the arguments properly' do
          expect(created_instruction).to eq Assembly::Instructions::Msg.new('mod(', :a, ', ', :b, ') = ', :d)
        end
      end

      context 'when given invalid arguments' do
        let(:raw_instruction) { "msg   'mod(, a, ', ', b, ') = ', d" }

        it 'throws and error' do
          expect { create_instruction }.to raise_error invalid_instruction_error
        end
      end
    end

    context 'given an invalid instruction name' do
      let(:raw_instruction) { 'vom  c, a' }

      it 'raises and error' do
        expect { create_instruction }.to raise_error invalid_instruction_error
      end
    end

    context 'when given a label' do
      let(:raw_instruction) { 'function:' }

      it 'returns a label object' do
        expect(created_instruction).to eq label(:function)
      end
    end
  end

  def label(identifier)
    Assembly::Instructions::Label.new(identifier)
  end
end
