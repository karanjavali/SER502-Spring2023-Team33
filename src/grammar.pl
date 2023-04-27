<program> ::= <block> '.'.

<block> ::= 'begin' <declare> 'end'
          | 'begin' <declare> ';' <command> 'end'.

<declare> ::= <declare1> ';' <declare>
            | <declare1>.

<declare1> ::= 'int' <variable> ':=' <digit>
             | 'int' <variable>
             | 'string' <variable> ':=' '"' <string> '"'
             | 'string' <variable>
             | 'bool' <variable> ':=' <boolean>
             | 'bool' <variable>.

<command> ::= <command1> ';' <command>
            | <command1>.

<command1> ::= <variable> ':=' <expression>
              | <expression> <relational> <expression>
              | 'if' <boolean> 'then' <command> 'else' <command> 'endif'
              | 'if' <command1> 'then' <command> 'else' <command> 'endif'
              | 'tern' <boolean> '?' <command> ':' <command> 'endtern'
              | 'tern' <command1> '?' <command> ':' <command> 'endtern'
              | 'for' <command1> <command1> '{' <command> '}' 'endforjava'
              | 'for' <variable> 'inrange' <digit> <digit> '{' <command> '}' 'endforpython'
              | 'while' <boolean> 'do' <command> 'endwhile'
              | 'while' <command1> 'do' <command> 'endwhile'
              | 'print' <expression>
              | <block>.

<expression> ::= <expression> '+' <temp1>
               | <expression> '-' <temp1>
               | <temp1>.

<temp1> ::= <temp1> '*' <temp2>
          | <temp1> '/' <temp2>
          | <temp2>.

<temp2> ::= '(' <expression> ')'
          | <variable>
          | <digit>
          | <variable> ':=' <expression>.

<boolean> ::= 'true'
            | 'false'
            | <expression> ':=' <expression>
            | 'not' <boolean>
            | <boolean> '>' <boolean>
            | <boolean> '>=' <boolean>
            | <boolean> '<' <boolean>
            | <boolean> '<=' <boolean>
            | <boolean> '==' <boolean>
            | <boolean> '!=' <boolean>
            | '!' <boolean>
            | <boolean> '&&' <boolean>
            | <boolean> '||' <boolean>.

<variable> ::= [a-zA-Z][a-zA-Z0-9_]*.

<digit> ::= [0-9]+.

<string> ::= [a-zA-Z]+.
