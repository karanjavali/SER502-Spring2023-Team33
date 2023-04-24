program(t_program(X)) --> block(X), ['.'].

block(t_block(X)) --> [begin], ['#'], instructions(X), ['#'], [end].

instructions(t_variable(X,Y)) --> variable_rule(X), ['#'], instructions(Y).
instructions(t_assignment(X,Y)) --> assignment_rule(X), ['#'], instructions(Y).
instructions(t_expression(X,Y)) --> expression(X), ['#'], instructions(Y).
instructions(t_ternary(X,Y)) --> ternary_rule(X), ['#'], instructions(Y).
instructions(t_conditional(X,Y)) --> conditional_rule(X), ['#'], instructions(Y).
instructions(t_for_java(X,Y)) --> for_javatype_rule(X), ['#'], instructions(Y).
instructions(t_for_python(X,Y)) --> for_pythontype_rule(X), ['#'], instructions(Y).
instructions(t_while(X,Y)) --> while_rule(X), ['#'], instructions(Y).
instructions(t_print(X,Y)) --> print_rule(X), ['#'], instructions(Y).

digits(t_digits(X)) --> digit(X).
digits(t_digits(X,Y)) --> digit(X), digits(Y).
digit(t_number_zero(X)) --> zero(X).
digit(t_number_nonzero(X)) --> non_zero(X).
zero(0) --> [0].
non_zero(1) --> [1].
non_zero(2) --> [2].
non_zero(3) --> [3].
non_zero(4) --> [4].
non_zero(5) --> [5].
non_zero(6) --> [6].
non_zero(7) --> [7].
non_zero(8) --> [8].
non_zero(9) --> [9].

variable(t_var(X)) --> char(X).
variable(t_var(X,Y)) --> char(X) variable(Y).
char(a) --> [a].
char(b) --> [b].
char(c) --> [c].
char(d) --> [d].
char(A) --> [A].
char(B) --> [B].
char(C) --> [C].
char(D) --> [D].
escapeChar("/n") --> ["/n"].

boolean(t_bool(X,Y)) --> [boolean], variable(X), [=], boolean(Y).
boolean(t_bool(X,Y)) --> variable(X), [=], boolean(Y).
boolean(t_true(true)) --> [true].
boolean(t_false(false)) --> [false].

integer(t_int(X,Y)) --> [int], variable(X), [=], digits(Y).
integer(t_int(X,Y)) --> variable(X), [=], digits(Y).

string(t_string(X)) --> [string], variable(X) ['"'], string(X), ['"'].
string(t_string(X)) --> variable(X) ['"'], string(X), ['"'].
string(t_string(X)) --> variable(X).
string(t_string(X)) --> escapeChar(X).

variable_rule(t_integer(X)) --> integer(X).
variable_rule(t_string(X)) --> string(X).
variable_rule(t_boolean(X)) --> boolean(X).

