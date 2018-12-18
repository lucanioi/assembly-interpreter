describe Assembly::Instructions::End do
  subject(:end_instruction) { described_class.new }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  describe '#execute' do
    it 'marks the program as finished' do
      subject.execute(program)

      expect(program).to be_finished
    end
  end
end
