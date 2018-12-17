describe Assembly::Instructions::Mov do
  subject(:mov_instruction) { described_class.new(register, value) }
  let(:register) { :a }
  let(:value) { 10 }
  let(:program) { double(:program) }
  let(:registry) { Assembly::Registry.new }

  before do
    allow(program).to receive(:registry) { registry }
    allow(program).to receive(:proceed)
  end

  describe '#execute' do
    context 'if initialized with a register and a value' do
      let(:value) { 9 }

      it 'copies the value in to the register' do
        expect(registry).to receive(:insert).with(value, {at: register})

        subject.execute(program)
      end
    end

    context 'if initialized with a register and another register' do
      let(:value) { :b }

      before do
        registry.insert(90, at: :b)
      end

      it 'copies the value in to the register' do
        expect(registry).to receive(:insert).with(90, {at: register})

        subject.execute(program)
      end
    end

    it 'tells the program to proceed' do
      expect(program).to receive(:proceed).once

      subject.execute(program)
    end
  end
end