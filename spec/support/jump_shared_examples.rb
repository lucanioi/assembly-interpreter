shared_examples 'jump if last cmp was' do |desired_cmp|
  subject(:jmp_instruction) { described_class.new(label) }
  let(:label) { :function }
  let(:program) { double(:program) }
  let(:cmp) { double(:cmp) }

  before do
    allow(program).to receive(:proceed)
    allow(program).to receive(:jump_to_subprogram)
    allow(program).to receive(:last_cmp) { cmp }
    allow(cmp).to receive(desired_cmp) { true }
  end

  describe '#execute' do
    context 'when last comparison was greater or equal' do
      it 'jumps to the subprogram at the given label' do
        expect(program).to receive(:jump_to_subprogram).with(label)

        subject.execute(program)
      end
    end

    context 'when last comparison was not greater or equal' do
      before do
        allow(cmp).to receive(desired_cmp) { false }
      end

      it 'does not jump to the given label' do
        expect(program).to_not receive(:jump_to_subprogram)

        subject.execute(program)
      end
    end

    it 'increments the instruction pointer' do
      expect(program).to receive(:proceed)

      subject.execute(program)
    end
  end
end