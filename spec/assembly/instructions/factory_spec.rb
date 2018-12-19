describe Assembly::Instructions::Factory do
  subject(:instruction_factory) { described_module }
  let(:create_instruction) { subject.create(instruction, *arguments) }
  let(:instruction) { :foo }
  let(:arguments) { [] }
  let(:created_instruction) { create_instruction }
  let(:invalid_instruction_error) { Assembly::Errors::InvalidInstruction }

  describe '#create' do
    context 'given a valid instruction name' do
      let(:instruction) { :mov }
      let(:arguments) { [:c, 4] }

      it 'creates an instance of the given instruction' do
        expect(created_instruction).to be_an_instance_of Assembly::Instructions::Mov
      end

      it 'creates the instance with the correct attributes' do
        expect(created_instruction).to eq Assembly::Instructions::Mov.new(:c, 4)
      end

      context 'given an invalid instruction name' do
        let(:instruction) { :vom }
        let(:arguments) { [:c, 'd'] }

        it 'raises and error' do
          expect { create_instruction }.to raise_error invalid_instruction_error
        end
      end

      context 'when given a label' do
        let(:instruction) { :'function:' }

        it 'returns a label object' do
          expect(created_instruction).to eq label(:function)
        end
      end
    end
  end

  def label(identifier)
    Assembly::Instructions::Label.new(identifier)
  end
end
