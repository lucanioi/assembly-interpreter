describe Assembly::Parser do
  subject(:parser) { described_module }
  let(:raw_program) do
    <<~PROGRAM
      mov  a, 5
      inc  a
      call function
      msg  'Hello', 10, a
      end

      function:
        dec a
        ret
    PROGRAM
  end
  let(:parse_instructions) { parser.parse_instructions(raw_program) }
  let(:parsed_instructions) { parse_instructions }
  let(:invalid_instruction_error) { Assembly::Errors::InvalidInstruction }

  describe '#parse_instructions' do
    it 'omits empty lines' do
      expect(parsed_instructions).to have(8).items
    end

    it 'translates each line into an array of instruction and arguments' do
      expect(parsed_instructions).to all(be_an(Array))
    end

    it 'translates instruction methods into symbols' do
      mov_instruction = parsed_instructions[0]
      instruction, *arguments = mov_instruction

      expect(instruction).to eq :mov
    end

    it 'translates register arguments into symbols' do
      mov_instruction = parsed_instructions[0]
      instruction, *arguments = mov_instruction

      expect(arguments.first).to eq :a
    end

    it 'translates number arguments into integers' do
      mov_instruction = parsed_instructions[0]
      instruction, *arguments = mov_instruction

      expect(arguments.last).to eq 5
    end

    it 'keeps string arguments as strings' do
      msg_instruction = parsed_instructions[3]
      instruction, *arguments = msg_instruction

      expect(arguments.first).to eq 'Hello'
    end

    it 'translates labels arguments into symbols' do
      msg_instruction = parsed_instructions[5]
      instruction, *arguments = msg_instruction

      expect(instruction).to eq :'function:'
    end

    context 'when program contains invalid methods' do
      let(:raw_program) do
        <<~PROGRAM
          mov  a, 5
          i?nc'  a
          end
        PROGRAM
      end

      it 'raises an invalid instruction error' do
        expect { parse_instructions }.to raise_error invalid_instruction_error
      end
    end

    context 'when program contains invalid arguments' do
      let(:raw_program) do
        <<~PROGRAM
          msg ?x, }{})
          end
        PROGRAM
      end

      it 'raises an invalid instruction error' do
        expect { parse_instructions }.to raise_error invalid_instruction_error
      end
    end

    context 'when program includes comments' do
      let(:raw_program) do
        <<~PROGRAM
          ; i am a comment
          mov  a, 5
          inc  a
          call function ; comment
          end
        PROGRAM
      end

      it 'omits the comments from the instruction lines' do
        expect(parsed_instructions).to have(4).items
      end
    end
  end
end
