OPERATORS = {
  multiplication: :*,
  division: :/,
  addition: :+,
  subtraction: :-
}.freeze

shared_examples 'arithmetic operation' do |operation|
  subject(:instruction) { described_class.new(target_register, source_register) }
  let(:target_register) { :a }
  let(:source_register) { :b }

  let(:operator) { OPERATORS[operation] || (raise 'Invalid operation for arithmetic shard examples!') }

  let(:value_x) { 100 }
  let(:value_y) { 25 }

  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  before do
    program.set_register(target_register, 100)
    program.set_register(source_register, 25) if source_register.is_a? Symbol
  end

  describe '#execute' do
    it 'adds the values together' do
      subject.execute(program)

      expected = value_x.send(operator, value_y)
      expect(program.get_register(target_register)).to eq expected
    end

    context 'when source register is just a raw-value integer' do
      let(:source_register) { 25 }

      it 'copies the integer into the register' do
        subject.execute(program)

        expected = value_x.send(operator, value_y)
        expect(program.get_register(target_register)).to eq expected
      end
    end

    it 'increments the instruction pointer' do
      original_pointer = program.instruction_pointer

      subject.execute(program)

      expected_pointer = original_pointer + 1
      expect(program.instruction_pointer).to eq expected_pointer
    end
  end
end
