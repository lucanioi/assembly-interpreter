describe Assembly::Instructions::Jmp do
  subject(:jmp_instruction) { described_class.new(label) }
  let(:label) { :function }
  let(:program) { double(:program) }

  before do
    allow(program).to receive(:jump_to_subprogram)
    allow(program).to receive(:proceed)
  end

  describe '#execute' do
    it 'jumps to the subprogram at the given label' do
      expect(program).to receive(:jump_to_subprogram).with(label)

      subject.execute(program)
    end

    it 'increments the instruction pointer' do
      expect(program).to receive(:proceed)

      subject.execute(program)
    end
  end
end