program_eval(t_program(P), VAL) :-
    eval_block(P, [], VAL).

eval_block(t_block(T1, T2), ENV, VAL) :- 
    eval_declaration(T1, ENV, NewENV),
    com_eval(T2, NewENV, VAL).

eval_block(t_block(T1), ENV, VAL) :- 
    eval_declaration(T1, ENV, VAL). 

eval_declaration(t_declare(T1, T2),ENV,NewENV) :- 
    eval_declaration(T1, ENV, NewENV1),
    eval_declaration(T2, NewENV1, NewENV).


eval_declaration(t_const(T1, T2), ENV, Env) :-
    (   T2 = t_digit(Num) % Check if T2 is a numeric literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id, NewENV, Num, Env)
    ;   write("ERROR: t_const second argument is not a numeric literal")
    ).

eval_declaration(t_string(T1, T2), ENV, Env) :-
    (   T2 = t_string(Str) % Check if T2 is a string literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id,NewENV, Str, Env)
    ;   write("ERROR: t_string second argument is not a string literal")
    ).
eval_declaration(t_bool(T1, T2), ENV, Env) :-
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

eval_num(t_bool(X),_ENV,X).
eval_num(t_var(X),_ENV,X).
eval_num(t_digit(X),_ENV,X).
eval_num(t_string(X),_ENV,X).


com_eval(t_command(X,Y),Env,NewEnv) :- 
    com1_eval(X,Env,NEnv),
    com_eval(Y,NEnv,NewEnv).

com_eval(X,Env,NewEnv) :- 
    com1_eval(X,Env,NewEnv).

%condition evaluation
com1_eval(t_conditional(X,Y,Z),Env,NewEnv) :-
    bool_eval(X,Env,Bool),
    ( Bool=true ->
        com_eval(Y,Env,NewEnv)
    ; Bool=false ->
        com_eval(Z,Env,NewEnv)
    ).

com1_eval(t_conditional(X,Y,Z), Env, NewEnv) :- 
    com1_eval(X,Env,Env1,R),
  	( R=true ->
        com_eval(Y,Env1,NewEnv)
    ; R=false ->
        com_eval(Z,Env1,NewEnv)
    ).
%assignment evaluation
com1_eval(t_assign(X,Y),Env,NewEnv) :-
    eval_num(X, Env, Id),
    expr_eval(Y,Env,NEnv,Val),
    update(Id,NEnv,Val,NewEnv).

%relation evaluation
com1_eval(t_booleanEquality(X,Y,Z),Env,NewEnv,R) :- 
    eval_num(X, Env, Id),
    lookup(Id,Env,Val1),
    expr_eval(Z,Env,NewEnv,Val2),
    relation_eval(Y,Val1,Val2,R).

%ternary evaluation
com1_eval(t_ternary(X,Y,Z),Env,NewEnv) :- 
    bool_eval(X,Env,Bool),
    ( Bool=true ->
        com_eval(Y,Env,NewEnv)
    ; Bool=false ->
        com_eval(Z,Env,NewEnv)
    ).
com1_eval(t_ternary(X,Y,Z),Env,NewEnv) :- 
    com1_eval(X,Env,Env1,R),
    ( R=true ->
        com_eval(Y,Env1,NewEnv)
    ; R=false ->
        com_eval(Z,Env1,NewEnv)
    ).
%while evaluation
com1_eval(t_while(X,Y),Env,NewEnv) :- bool_eval(X,Env,Bool),
     write(Env),
    ( Bool=true ->
        write('begin while'),
        com_eval(Y,Env,NEnv),
        com1_eval(t_while(X,Y),NEnv,NewEnv)
    ; Bool=false ->
    	NewEnv = Env,
        write('end while')
    ).

%print evaluation
com1_eval(t_print(X),Env,_Env) :- 
    write('begin print'),
    eval_print(X,Env).

eval_print(printExpr(X), Env):- expr_eval(X, Env, _Env, Val), write(Val),nl.
eval_print(printExpr(X), Env):- bool_eval(X, Env,R), write(R),nl.
eval_print(printString(X),_Env):- write(X),nl.

%for loop evaluation
com1_eval(t_for_javatype(X,Y,Z),Env,NewEnv) :- com1_eval(X,Env,Env1),
    bool_eval(Y,Env1,Bool),
    (   Bool=true ->  
        write('begin for javatype loop'),
        com_eval(Z,Env1,Env2),
        com1_eval(t_for_javatype(X,Y,Z),Env2,NewEnv)
    ;   Bool=false ->  
    	NewEnv = Env1,
        write('end for javatype loop')
    ).

%python for loop evaluation
com1_eval(t_for_pythontype(W,t_digit(Start),t_digit(End),Z),Env1,NewEnv) :- 
    (Start >= End ->
        % If Start is greater than End, just return the original environment
        NewEnv = Env1
    ; % Otherwise, iterate from Start to End
        write('Processing iteration: '), write(Start), nl,
        com_eval(Z,Env1,Env2),
        Next is Start + 1,
        write(Next),
        com1_eval(t_for_pythontype(W,t_digit(Next),t_digit(End),Z),Env2, NewEnv)
    ).

%evaluate the boolean
bool_eval(true,_Env,true).
bool_eval(false,_Env,false).
bool_eval(t_booleanEquality(X,Y,Z),Env,R) :- 
    eval_num(X, Env, Id),
    lookup(Id,Env,Val1),nl,
    expr_eval(Z,Env,Env,Val2), nl, nl,
    relation_eval(Y,Val1,Val2,R),
    write(R).
bool_eval(t_booleanNotEquality(X),Env,true):- bool_eval(X,Env,Bool), Bool = false.
bool_eval(t_booleanNotEquality(X),Env,false):- bool_eval(X,Env,Bool), Bool = true.

%new evaluate
expr_eval(t_boolean(X),ENV,ENV,X).
expr_eval(t_digit(X),ENV,ENV,X).
expr_eval(t_string(X),ENV,ENV,X).

%evaluate the expression
expr_eval(X, Env, Env, Val) :- 
    eval_num(X, Env, Id),
    lookup(Id, Env, Val).
expr_eval(X, Env, Env, Val) :- temp1_eval(X, Env, Env, Val).
expr_eval(t_add(X,Y), Env, NewEnv, Val) :-
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
lookup(Id,[(Id,Val)|_], Val).
lookup(Id,[_H|T], Val):-
    lookup(Id, T, Val).
lookup(_Id,[],_Val).

update(V,[],NewVal,[(V,NewVal)]).
update(V,[(V,_)|T],NewVal,[(V,NewVal)|T]).
update(V,[H|T],NewVal,[H|NewEnv]):-H\=(V,_),update(V,T,NewVal,NewEnv).

notContain(_Id, []).
notContain(Id, [(Id,_)|_]) :-
    throw(duplicate_variable_name(Id)).
notContain(Id, [(Id1,_)|T]) :-
    Id \= Id1,
    notContain(Id, T).