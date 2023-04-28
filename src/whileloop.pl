:- use_rendering(svgtree).

:- table expression/3, temp1/3, declare/3, expr_eval/3.


relational(>) --> [>].
relational(>=) --> [>=].
relational(<) --> [<].
relational(<=) --> [<=].
relational(==) --> [==].
relational('!=') --> ['!='].
relational(!) --> [!].
relational(&&) --> [&&].
relational('||') --> ['||'].

boolean(t_boolean(true)) --> [true].
boolean(t_boolean(false)) --> [false].
boolean(t_booleanEquality(X,Y,Z)) --> expression(X), relational(Y), expression(Z).
boolean(t_booleanNotEquality(X)) --> [not], boolean(X).

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

command1(t_conditional(X,Y,Z)) --> [if], boolean(X), [then], command(Y), [else], command(Z), [endif].

command1(t_ternary(X,Y,Z)) --> [tern], boolean(X), [?], command(Y), [:], command(Z), [endtern].

command1(t_for_javatype(X,Y,Z)) --> [for], command1(X), boolean(Y), ['{'], command(Z), ['}'], [endforjava].
command1(t_for_pythontype(W,X,Y,Z)) --> [for], variable(W), [inrange], digit(X), digit(Y), ['{'], command(Z), ['}'], [endforpython].

command1(t_while(X,Y)) --> [while], boolean(X), [do], command(Y), [endwhile].

command1(t_print(X)) --> [print], expression(X).

command1(X) --> block(X).


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

program_eval(t_program(P), VAL) :-
    eval_block(P, [], VAL).

eval_block(t_block(T1, T2), ENV, VAL) :- 
    eval_declaration(T1, ENV, NewENV),
    com_eval(T2, NewENV, VAL).
    %write("test"),
    %lookup(z,NewENV1,VAL).

eval_block(t_block(T1), ENV, VAL) :- 
    eval_declaration(T1, ENV, VAL). 
    %lookup(z,NewENV,VAL).

eval_declaration(t_declare(T1, T2),ENV,NewENV) :- 
    eval_declaration(T1, ENV, NewENV1),
    eval_declaration(T2, NewENV1, NewENV).


eval_declaration(t_const(T1, T2), ENV, Env) :-
    %write("assign int "),
    (   T2 = t_digit(Num) % Check if T2 is a numeric literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id, NewENV, Num, Env)
    ;   write("ERROR: t_const second argument is not a numeric literal")
    ).

eval_declaration(t_string(T1, T2), ENV, Env) :-
    %write("assign string "),
    (   T2 = t_string(Str) % Check if T2 is a string literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id,NewENV, Str, Env)
    ;   write("ERROR: t_string second argument is not a string literal")
    ).
eval_declaration(t_bool(T1, T2), ENV, Env) :-
    write("assign boolean "),
    (   T2 = t_boolean(Bool) % Check if T2 is a string literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id, NewENV, Bool, Env)
    ;   write("ERROR: t_bool second argument is not a boolean literal")
    ).

eval_declaration(t_const(T),ENV, NewENV) :- 
    eval_num(T,ENV,Id), 
    notContain(Id, ENV),
    add(Id,_,ENV, NewENV).

eval_declaration(t_string(T),ENV, NewENV) :- 
    eval_num(T,ENV,Id), 
    notContain(Id, ENV), 
    add(Id,_,ENV, NewENV).

eval_declaration(t_bool(T),ENV, NewENV) :- 
    eval_num(T,ENV,Id), 
    notContain(Id, ENV), 
    add(Id,_,ENV, NewENV).

eval_declaration(t_const(_T),ENV, ENV).  
eval_declaration(t_string(_T),ENV, ENV).
eval_declaration(t_bool(_T),ENV, ENV).

eval_num(t_var(X),_ENV,X).
eval_num(t_digit(X),_ENV,X).
eval_num(t_string(X),_ENV,X).
eval_num(t_bool(X),_ENV,X).

com_eval(t_command(X,Y),Env,NewEnv) :- 
     %write('t_command Env: '), write(Env), nl,
    com1_eval(X,Env,NEnv),
     %write('t_command NEnv: '), write(NEnv), nl,
    com_eval(Y,NEnv,NewEnv).
com_eval(X,Env,NewEnv) :- 
    write('com_eval '),write(X), nl,
    com1_eval(X,Env,NewEnv).

%condition evaluation
com1_eval(t_conditional(X,Y,Z),Env,NewEnv) :-
    bool_eval(X,Env,Bool),
    ( Bool=true ->
        com_eval(Y,Env,NewEnv)
    ; Bool=false ->
        com_eval(Z,Env,NewEnv)
    ).

%assignment evaluation
com1_eval(t_assign(X,Y),Env,NewEnv) :-
    %write("test assign"), nl,
    eval_num(X, Env, Id), nl,
    %lookup(Id, Env, _),
    expr_eval(Y,Env,NEnv,Val),
    update(Id,NEnv,Val,NewEnv).

%relation evaluation
com1_eval(t_booleanEquality(X,Y,Z),Env,NewEnv,R) :- 
    write('Compare: '),nl,
    write('X: '), write(X), nl,
    write('Y: '), write(Y), nl,
    write('Z: '), write(Z), nl,
    eval_num(X, Env, Id),
    lookup(Id,Env,Val1),nl,
    write('X: '), write(Val1), nl,
    expr_eval(Z,Env,NewEnv,Val2), nl, nl,
    write('Z: '), write(Val2), nl,
    write('Y: '), write(Y), nl,
    relation_eval(Y,Val1,Val2,R),
    write(R).

%ternary evaluation
com1_eval(t_ternary(X,Y,Z),Env,NewEnv) :- 
    bool_eval(X,Env,Bool),
    ( Bool=true ->
        com_eval(Y,Env,NewEnv)
    ; Bool=false ->
        com_eval(Z,Env,NewEnv)
    ).
%com1_eval(t_ternary(X,Y,_Z),Env,NewEnv) :- com1_eval(X,Env,Env1,R),R=true,
    %com_eval(Y,Env1,NewEnv).
%com1_eval(t_ternary(X,_Y,Z),Env,NewEnv) :- com1_eval(X,Env,Env1,R),R=false,
    %com_eval(Z,Env1,NewEnv).

%while evaluation
com1_eval(t_while(X,Y),Env,NewEnv) :- bool_eval(X,Env,Bool),
    ( Bool=true ->
        write('begin while'),
        com_eval(Y,Env,NEnv),
        com1_eval(t_while(X,Y),NEnv,NewEnv)
    ; Bool=false ->
        write('end while')
    ).

%for loop evaluation
com1_eval(t_for_javatype(X,Y,Z),Env,NewEnv) :- com1_eval(X,Env,Env1),
    bool_eval(Y,Env1,Bool),
    (   Bool=true ->  
        write('begin for javatype loop'),
        com_eval(Z,Env1,NewEnv)
    ;   Bool=false ->  
        write('end for javatype loop')
    ).

%evaluate the boolean
bool_eval(true,_Env,true).
bool_eval(false,_Env,false).
bool_eval(t_booleanEquality(X,Y,Z),Env,R) :- 
    write('Compare:1 '),nl,
    write('X: '), write(X), nl,
    write('Y: '), write(Y), nl,
    write('Z: '), write(Z), nl,
    eval_num(X, Env, Id),
    lookup(Id,Env,Val1),nl,
    write('X: '), write(Val1), nl,
    expr_eval(Z,Env,Env,Val2), nl, nl,
    write('Z: '), write(Val2), nl,
    write('Y: '), write(Y), nl,
    relation_eval(Y,Val1,Val2,R),
    write(R).
bool_eval(t_booleanNotEquality(X),Env,true):- bool_eval(X,Env,Bool), Bool = false.
bool_eval(t_booleanNotEquality(X),Env,false):- bool_eval(X,Env,Bool), Bool = true.

%new evaluate
expr_eval(t_digit(X),ENV,ENV,X).
expr_eval(t_string(X),ENV,ENV,X).
expr_eval(t_boolean(X),ENV,ENV,X).

%evaluate the expression
expr_eval(X, Env, Env, Val) :- 
    %write("Env "), write(Env), nl,
    %write("X "), write(X), nl,
    eval_num(X, Env, Id),
    %write("Id"), write(Id), nl,
    lookup(Id, Env, Val).
    %write("Val"), write(Val), nl,
    %write(Val).
expr_eval(X, Env, Env, Val) :- temp1_eval(X, Env, Env, Val).
expr_eval(t_add(X,Y), Env, NewEnv, Val) :-
    %write("add "), write(X), write(Y), nl,
    expr_eval(X, Env, NEnv,V1),
    temp1_eval(Y, NEnv, NewEnv,V2), 
    Val is V1 + V2.
expr_eval(t_sub(X,Y), Env, NewEnv, Val) :- expr_eval(X, Env, NEnv,V1), 
    temp1_eval(Y, NEnv, NewEnv,V2), Val is V1 - V2.

%evaluate temp1 expression
temp1_eval(t_digit(X),Env,Env,X).
temp1_eval(t_var(X),Env,Env,Val):- lookup(X, Env, Val).
temp1_eval(T,Env,Env,Val) :- temp2_eval(T,Env,Env,Val).
temp1_eval(T,Env,Env,Val) :-
    eval_num(T, Env, Id),
    lookup(Id, Env, Val).
temp1_eval(t_multiply(X,Y), Env, NewEnv, Val) :- temp1_eval(X, Env, NEnv,Val1),
    temp2_eval(Y,NEnv,NewEnv,Val2),Val is Val1 * Val2.
temp1_eval(t_divide(X,Y), Env, NewEnv, Val) :- temp1_eval(X, Env, NEnv,Val1),
    temp2_eval(Y,NEnv,NewEnv,Val2),Val is Val1 / Val2.

%evaluate temp2 expression
temp2_eval(t_digit(X),Env,Env,X).
temp2_eval(t_var(X),Env,Env,X).
temp2_eval(t_parenthesis(X),Env,NewEnv,Val) :- expr_eval(X,Env,NewEnv,Val).
temp2_eval(t_assign(X,Y),Env,NewEnv,Val) :- expr_eval(Y,Env,NEnv,Val),
    update(X,NEnv,Val,NewEnv).
temp2_eval(T,Env,Env,Val) :-
    eval_num(T, Env, Id),
    lookup(Id, Env, Val).

%evaluate relational
relation_eval('>', X, Y, R) :- greaterCheck(X, Y, R).
relation_eval('>=', X, Y, R) :- greaterEqualCheck(X, Y, R).
relation_eval('<', X, Y, R) :- lowerCheck(X, Y, R).
relation_eval('<=', X, Y, R) :- lowerEqualCheck(X, Y, R).
relation_eval('==', X, Y, R) :- equalCheck(X, Y, R).
relation_eval('!=', X, Y, R) :- notequalCheck(X, Y, R).
relation_eval(!, _, _, R) :- R = false.
relation_eval(&&,X,Y,R) :- X = true, Y = false, R = false.
relation_eval(&&,X,Y,R) :- X = false, Y = false, R = false.
relation_eval(&&,X,Y,R) :- X = false, Y = true, R = false.
relation_eval(&&,X,Y,R) :- X = true, Y = true, R = true.
relation_eval('||',X,Y,R) :- X = true, Y = false, R = true.
relation_eval('||',X,Y,R) :- X = false, Y = false, R = false.
relation_eval('||',X,Y,R) :- X = false, Y = true, R = true.
relation_eval('||',X,Y,R) :- X = true, Y = true, R = true.

greaterCheck(X, Y, true):- X > Y.
greaterCheck(X, Y, false):- X =< Y.
greaterEqualCheck(X, Y, true):- X >= Y.
greaterEqualCheck(X, Y, false):- X < Y.
lowerCheck(X, Y, true):- X < Y.
lowerCheck(X, Y, false):- X >= Y.
lowerEqualCheck(X, Y, true):- X =< Y.
lowerEqualCheck(X, Y, false):- X > Y.
equalCheck(X, Y, true):- X == Y.
equalCheck(X, Y, false):- dif(X, Y).
notequalCheck(X, Y, true):- dif(X, Y).
notequalCheck(X, Y, false):- X == Y.

add(Id, NewVal,L,[(Id, NewVal)|L]).
lookup(Id,[(Id,Val)|_], Val):- write("lookup").
lookup(Id,[H|T], Val):-
    write("Pair: "),write(H), nl,
    write("Id: "),write(Id), nl,
    lookup(Id, T, Val).
lookup(Id,[],_Val):-write(Id),write(" not exist.").

update(V,[],NewVal,[(V,NewVal)]):- write("cant not find").
update(V,[(V,_)|T],NewVal,[(V,NewVal)|T]):- write(NewVal).
update(V,[H|T],NewVal,[H|NewEnv]):-H\=(V,_),update(V,T,NewVal,NewEnv).

notContain(_Id, []).
notContain(Id, [(Id,_)|_]) :-
    throw(duplicate_variable_name(Id)).
notContain(Id, [(Id1,_)|T]) :-
    Id \= Id1,
    notContain(Id, T).

