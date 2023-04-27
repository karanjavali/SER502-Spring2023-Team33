:- use_rendering(svgtree).

:- table expression/3, temp1/3, declare/3, expr_eval/3.

program(t_program(X)) --> block(X), ['.'].

block(t_block(X)) --> [begin], declare(X), [end].
block(t_block(X,Y)) --> [begin], declare(X), [;], command(Y), [end].


declare(t_declare(X,Y)) --> declare1(X), [;], declare(Y).
declare(X) --> declare1(X).

declare1(t_const(X)) --> [int], variable(X).
declare1(t_const(X,Y)) --> [int], variable(X), [:=], digit(Y).

declare1(t_string(X,Y)) --> [string], variable(X), [:=], ['"'], string(Y), ['"'].
declare1(t_string(X)) --> [string], variable(X).

declare1(t_bool(X,Y)) --> [bool], variable(X), [:=], boolean(Y).
declare1(t_bool(X)) --> [bool], variable(X).


command(t_command(X,Y)) --> command1(X), [;], command(Y).
command(X) --> command1(X).

command1(t_assign(X,Y)) --> variable(X), [:=], expression(Y).

command1(t_relational(X,Y,Z)) --> variable(X), relational(Y), expression(Z).

command1(t_conditional(X,Y,Z)) --> [if], boolean(X), [then], command(Y), [else], command(Z), [endif].
command1(t_conditional(X,Y,Z)) --> [if], command1(X), [then], command(Y), [else], command(Z), [endif].

command1(t_ternary(X,Y,Z)) --> [tern], boolean(X), [?], command(Y), [:], command(Z), [endtern].
command1(t_ternary(X,Y,Z)) --> [tern], command1(X), [?], command(Y), [:], command(Z), [endtern].

command1(t_for_javatype(X,Y,Z)) --> [for], command1(X), command1(Y), ['{'], command(Z), ['}'], [endforjava].
command1(t_for_pythontype(W,X,Y,Z)) --> [for], variable(W), [inrange], digit(X), digit(Y), ['{'], command(Z), ['}'], [endforpython].

command1(t_while(X,Y)) --> [while], boolean(X), [do], command(Y), [endwhile].
command1(t_while(X,Y)) --> [while], command1(X), [do], command(Y), [endwhile].

command1(X) --> block(X).

boolean(t_boolean(true)) --> [true].
boolean(t_boolean(false)) --> [false].
boolean(t_booleanEquality(X,Y)) --> expression(X), [=], expression(Y).
boolean(t_booleanNotEquality(X)) --> [not], boolean(X).

relational(>) --> [>].
relational('>=') --> ['>='].
relational(<) --> [<].
relational('<=') --> ['<='].
relational('==') --> ['=='].
relational('!=') --> ['!='].
relational(!) --> [!].

expression(t_add(X,Y)) --> expression(X), [+], temp1(Y).
expression(t_sub(X,Y)) --> expression(X), [-], temp1(Y).
expression(X) --> temp1(X).
temp1(t_multiply(X,Y)) --> temp1(X), [*], temp2(Y).
temp1(t_divide(X,Y)) --> temp1(X), [/], temp2(Y).
temp1(X) --> temp2(X).
temp2(t_parenthesis(X)) --> ['('], expression(X), [')'].
temp2(t_assign(X,Y)) --> variable(X), [:=], expression(Y).
temp2(t_var(X)) --> [X], { atom(X) }.
temp2(t_digit(X)) --> [X], { number(X) }.
%temp2(t_string(X)) --> [X], { atom(X) }.

variable(t_var(X)) --> [X], { atom(X) }.

digit(t_digit(I)) --> [I], { number(I) }.

string(t_string(S)) --> [S], { atom(S) }.