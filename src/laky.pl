:- use_rendering(svgtree).

:- table expression/3, temp1/3.


variable(x) --> [x].
variable(y) --> [y].
variable(z) --> [z].
variable(u) --> [u].
variable(v) --> [v].

number(t_digit(X)) --> digit(X).
number(t_digit(X,Y)) --> digit(X), number(Y).
digit(0) --> [0].
digit(1) --> [1].
digit(2) --> [2].
digit(3) --> [3].
digit(4) --> [4].
digit(5) --> [5].
digit(6) --> [6].
digit(7) --> [7].
digit(8) --> [8].
digit(9) --> [9].

string(t_string(X)) --> chars(X).
string(t_string(X,Y)) --> chars(X), string(Y).
chars(a) --> [a].
chars(b) --> [b].
chars(c) --> [c].
chars(d) --> [d].
chars(e) --> [e].
chars(f) --> [f].
chars(g) --> [g].
chars(h) --> [h].
chars(i) --> [i].
chars(j) --> [j].
chars(k) --> [k].
chars(l) --> [l].
chars('m') --> ['m'].
chars(n) --> [n].
chars(o) --> [o].
chars(p) --> [p].
chars('q') --> ['q'].
chars(r) --> [r].
chars('s') --> ['s'].
chars(t) --> [t].
chars(u) --> [u].
chars(v) --> [v].
chars(w) --> [w].
chars(x) --> [x].
chars(y) --> [y].
chars(z) --> [z].

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


program(t_program(X)) --> block(X), ['.'].

block(t_block(X,Y)) --> [begin], declare(X), [;], command(Y), [end].


declare(t_declare(X,Y)) --> declare1(X), [;], declare(Y).
declare(X) --> declare1(X).

declare1(t_const(X,Y)) --> [int], variable(X), [=], number(Y).
declare1(t_const(X)) --> [int], variable(X).

declare1(t_string(X,Y)) --> [string], variable(X), [=], ['"'], string(Y), ['"'].
declare1(t_string(X)) --> [string], variable(X).

declare1(t_bool(X,Y)) --> [bool], variable(X), [=], boolean(Y).
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
command1(t_for_pythontype(W,X,Y,Z)) --> [for], variable(W), [inrange], number(X), number(Y), ['{'], command(Z), ['}'], [endforpython].

command1(t_while(X,Y)) --> [while], boolean(X), [do], command(Y), [endwhile].
command1(t_while(X,Y)) --> [while], command1(X), [do], command(Y), [endwhile].

command1(X) --> block(X).


expression(t_add(X,Y)) --> expression(X), [+], temp1(Y).
expression(t_sub(X,Y)) --> expression(X), [-], temp1(Y).
expression(X) --> temp1(X).
temp1(t_multiply(X,Y)) --> temp1(X), [*], temp2(Y).
temp1(t_divide(X,Y)) --> temp1(X), [/], temp2(Y).
temp1(X) --> temp2(X).
temp2(t_parenthesis(X)) --> ['('], expression(X), [')'].
temp2(t_assign(X,Y)) --> variable(X), [:=], expression(Y).
temp2(t_variable(X)) --> variable(X).
temp2(t_number(X)) --> number(X).
