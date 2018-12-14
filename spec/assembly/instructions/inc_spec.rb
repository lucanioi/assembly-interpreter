describe Assembly::Instructions::Inc do
  subject(:inc_instruction) { described_class.new(register) }
  let(:register) { :a }
  let(:program) { double(:program) }
  let(:registry) { double(:registry) }

  before do
    allow(registry).to receive(:read) { -18 }
    allow(registry).to receive(:insert)
    allow(program).to receive(:registry) { registry }
    allow(program).to receive(:proceed)
  end

  describe '#execute' do
    it 'increments the value in the register by one' do
      expect(registry).to receive(:insert).with(-17, {at: :a})

      inc_instruction.execute(program)
    end

    it 'tells the program to proceed' do
      expect(program).to receive(:proceed)

      subject.execute(program)
    end
  end
end