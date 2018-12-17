describe Assembly::Instructions::Call do
  subject(:call_instruction) { described_class.new(label) }
  let(:label) { :function }
  let(:program) { double(:program) }

  before do
    allow(program).to receive(:call_subprogram)
    allow(program).to receive(:proceed)
  end

  describe '#execute' do
    it 'calls the subprogram at the given label' do
      expect(program).to receive(:call_subprogram).with(label)

      subject.execute(program)
    end

    it 'increments the instruction pointer' do
      expect(program).to receive(:proceed)

      subject.execute(program)
    end
  end
end