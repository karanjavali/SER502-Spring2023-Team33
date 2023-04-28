<program> ::= <block> '.'
<block> ::= 'begin' <declare> 'end'
           | 'begin' <declare> ';' <command> 'end'
<declare> ::= <declare1> ';'
             | <declare1> ';' <declare>
<declare1> ::= 'int' <variable>
              | 'int' <variable> ':=' <digit>
              | 'string' <variable>
              | 'string' <variable> ':=' <string>
              | 'bool' <variable>
              | 'bool' <variable> ':=' <boolean>
<boolean> ::= 'true'
             | 'false'
             | <expression> <relational> <expression>
             | 'not' <boolean>
<command> ::= <command1> ';'
              | <command1> ';' <command>
<command1> ::= <variable> ':=' <expression>
               | 'if' <boolean> 'then' <command> 'else' <command> 'endif'
               | 'tern' <boolean> '?' <command> ':' <command> 'endtern'
               | 'for' <command1> <boolean> '{' <command> '}' 'endforjava'
               | 'for' <variable> 'inrange' <digit> <digit> '{' <command> '}' 'endforpython'
               | 'while' <boolean> 'do' <command> 'endwhile'
               | 'print' <expression>
               | <block>
<expression> ::= <temp1>
                 | <expression> '+' <temp1>
                 | <expression> '-' <temp1>
<temp1> ::= <temp2>
            | <temp1> '*' <temp2>
            | <temp1> '/' <temp2>
<temp2> ::= '(' <expression> ')'
            | <variable> ':=' <expression>
            | <variable>
            | <digit>
<string> ::= '"' <string> '"'
<variable> ::= <identifier>
<digit> ::= <integer>
<relational> ::= '>' | '>=' | '<' | '<=' | ':=' | '!=' | '!' | '&&' | '||'
<identifier> ::= <alphabetic> <identifier> | <alphabetic>
<alphabetic> ::= 'a' | 'b' | 'c' | ... | 'y' | 'z' | 'A' | 'B' | 'C' | ... | 'Y' | 'Z'
<integer> ::= <digit> <integer> | <digit>
