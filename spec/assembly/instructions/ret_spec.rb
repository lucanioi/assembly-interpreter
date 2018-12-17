describe Assembly::Instructions::Ret do
  subject(:ret_instruction) { described_class.new }
  let(:program) { double(:program) }

  before do
    allow(program).to receive(:return_to_last_target)
    allow(program).to receive(:proceed)
  end

  describe '#execute' do
    it 'returns the program to the last subprogram caller' do
      expect(program).to receive(:return_to_last_target)

      subject.execute(program)
    end

    it 'increments the instruction pointer' do
      expect(program).to receive(:proceed)

      subject.execute(program)
    end
  end
end