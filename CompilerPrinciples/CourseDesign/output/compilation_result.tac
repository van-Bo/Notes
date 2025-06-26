--- TAC for Expression #1: "10 + 2 * 6" ---
t0 = 10
t1 = 2
t2 = 6
t3 = t1 MUL t2
t4 = t0 PLUS t3

--- TAC for Expression #2: "(10 + 2) * 6" ---
t0 = 10
t1 = 2
t2 = t0 PLUS t1
t3 = 6
t4 = t2 MUL t3

--- TAC for Expression #3: "100 / 10 / 2" ---
t0 = 100
t1 = 10
t2 = t0 DIV t1
t3 = 2
t4 = t2 DIV t3

--- TAC for Expression #4: "10 - 2 - 3" ---
t0 = 10
t1 = 2
t2 = t0 MINUS t1
t3 = 3
t4 = t2 MINUS t3

--- TAC for Expression #5: "-5 * (-2 + 1)" ---
t0 = 5
t1 = -t0
t2 = 2
t3 = -t2
t4 = 1
t5 = t3 PLUS t4
t6 = t1 MUL t5

--- TAC for Expression #6: "8 >> 1 + 2" ---
t0 = 8
t1 = 1
t2 = 2
t3 = t1 PLUS t2
t4 = t0 RSHIFT t3

--- TAC for Expression #7: "(8 >> 1) + 2" ---
t0 = 8
t1 = 1
t2 = t0 RSHIFT t1
t3 = 2
t4 = t2 PLUS t3

--- TAC for Expression #8: "10 | 3 & 5" ---
t0 = 10
t1 = 3
t2 = 5
t3 = t1 AND t2
t4 = t0 OR t3

--- TAC for Expression #9: "(10 | 3) & 5" ---
t0 = 10
t1 = 3
t2 = t0 OR t1
t3 = 5
t4 = t2 AND t3

--- TAC for Expression #10: "255 & 15 << 1" ---
t0 = 255
t1 = 15
t2 = 1
t3 = t1 LSHIFT t2
t4 = t0 AND t3

--- TAC for Expression #11: "0xFF + 0b1010" ---
t0 = 255
t1 = 10
t2 = t0 PLUS t1

--- TAC for Expression #12: "100 * 0x10" ---
t0 = 100
t1 = 16
t2 = t0 MUL t1

--- TAC for Expression #13: "10 / 0" ---
t0 = 10
t1 = 0
t2 = t0 DIV t1

--- TAC for Expression #14: "5 * ( 2 + 3" ---
Error: Parser error: Unexpected token. Expected RPAREN, but got EOF

--- TAC for Expression #15: "10 & & 5" ---
Error: Parser error: Invalid syntax in factor.

--- TAC for Expression #16: "@ + 1" ---
Error: Lexer error: Invalid character '@' at position 0

--- TAC for Expression #17: "10 +" ---
Error: Parser error: Invalid syntax in factor.

