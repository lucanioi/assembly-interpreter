xdescribe "Integration" do
  let(:interpreter) { Assembly::Interpreter.new }

  describe '#interpret' do
    it 'simple program' do
      simple_program = <<~PROGRAM
        ; My first program
        mov  a, 5
        inc  a
        call function
        msg  '(5+1)/2 = ', a    ; output message
        end

        function:
            div  a, 2
            ret
      PROGRAM

      expect(interpreter.interpret(simple_program)).to eq('(5+1)/2 = 3')
    end

    it 'factorial program' do
      factorial_program = <<~PROGRAM
        mov   a, 5
        mov   b, a
        mov   c, a
        call  proc_fact
        call  print
        end

        proc_fact:
            dec   b
            mul   c, b
            cmp   b, 1
            jne   proc_fact
            ret

        print:
            msg   a, '! = ', c ; output text
            ret
      PROGRAM

      expect(interpreter.interpret(factorial_program)).to eq('5! = 120')
    end

    it 'fibonacci program' do
      fibonacci_program = <<~PROGRAM
        mov   a, 8            ; value
        mov   b, 0            ; next
        mov   c, 0            ; counter
        mov   d, 0            ; first
        mov   e, 1            ; second
        call  proc_fib
        call  print
        end

        proc_fib:
            cmp   c, 2
            jl    func_0
            mov   b, d
            add   b, e
            mov   d, e
            mov   e, b
            inc   c
            cmp   c, a
            jle   proc_fib
            ret

        func_0:
            mov   b, c
            inc   c
            jmp   proc_fib

        print:
            msg   'Term ', a, ' of Fibonacci series is: ', b        ; output text
            ret      
      PROGRAM

      expect(interpreter.interpret(fibonacci_program)).to eq('Term 8 of Fibonacci series is: 21')
    end

    it 'modulo program' do
      modulo_program = <<~PROGRAM
        mov   a, 11           ; value1
        mov   b, 3            ; value2
        call  mod_func
        msg   'mod(', a, ', ', b, ') = ', d        ; output
        end

        ; Mod function
        mod_func:
            mov   c, a        ; temp1
            div   c, b
            mul   c, b
            mov   d, a        ; temp2
            sub   d, c
            ret        
      PROGRAM

      expect(interpreter.interpret(modulo_program)).to eq('mod(11, 3) = 2')
    end

    it 'gcd program' do
      gcd_program = <<~PROGRAM
        mov   a, 81         ; value1
        mov   b, 153        ; value2
        call  init
        call  proc_gcd
        call  print
        end

        proc_gcd:
            cmp   c, d
            jne   loop
            ret

        loop:
            cmp   c, d
            jg    a_bigger
            jmp   b_bigger

        a_bigger:
            sub   c, d
            jmp   proc_gcd

        b_bigger:
            sub   d, c
            jmp   proc_gcd

        init:
            cmp   a, 0
            jl    a_abs
            cmp   b, 0
            jl    b_abs
            mov   c, a            ; temp1
            mov   d, b            ; temp2
            ret

        a_abs:
            mul   a, -1
            jmp   init

        b_abs:
            mul   b, -1
            jmp   init

        print:
            msg   'gcd(', a, ', ', b, ') = ', c
            ret      
      PROGRAM

      expect(interpreter.interpret(gcd_program)).to eq('gcd(81, 153) = 9')
    end

    it 'fail program' do
      fail_program = <<~PROGRAM
        call  func1
        call  print
        end

        func1:
            call  func2
            ret

        func2:
            ret

        print:
            msg 'This program should return -1' 
      PROGRAM

      expect(interpreter.interpret(fail_program)).to eq(-1)
    end

    it 'exponent program' do
      exponent_program = <<~PROGRAM
        mov   a, 2            ; value1
        mov   b, 10           ; value2
        mov   c, a            ; temp1
        mov   d, b            ; temp2
        call  proc_func
        call  print
        end

        proc_func:
            cmp   d, 1
            je    continue
            mul   c, a
            dec   d
            call  proc_func

        continue:
            ret

        print:
            msg a, '^', b, ' = ', c
            ret      
      PROGRAM

      expect(interpreter.interpret(exponent_program)).to eq('2^10 = 1024')
    end
  end
end