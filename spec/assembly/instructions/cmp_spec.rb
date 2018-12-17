describe Assembly::Instructions::Cmp do
  subject(:cmp_instruction) { described_class.new(x, y) }
  let(:x) { 10 }
  let(:y) { 12 }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { double(:registry) }
  let(:instruction_set) { double(:instruction_set) }

  describe '#execute' do
    context 'when the given values are integers' do
      it 'sets the last cmp of the program with the integers' do
        cmp_instruction.execute(program)

        expected = Assembly::Comparison.new(x, y)
        expect(program.last_cmp).to eq expected
      end
    end

    context 'when the given values are registers' do
      let(:x) { :a }
      let(:y) { :b }

      before do
        allow(registry).to receive(:read).with(:a) { 8 }
        allow(registry).to receive(:read).with(:b) { 12 }
      end

      it 'sets the last cmp of the program' do
        cmp_instruction.execute(program)

        expected = Assembly::Comparison.new(8, 12)
        expect(program.last_cmp).to eq expected
      end
    end

    it 'calls proceed on the program' do
      expect(program).to receive(:proceed).once

      cmp_instruction.execute(program)
    end
  end
end