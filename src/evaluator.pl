program_eval(t_program(P), VAL) :-
    eval_block(P, [], VAL).

eval_block(t_block(T1), ENV, VAL) :-
    eval_declaration(T1, ENV, NewENV),
	lookup(Z,NewENV,VAL).

eval_declaration(t_declare(T1, T2),ENV,NewENV) :- 
    eval_declaration(T1, ENV, NewENV1),
    write("Test"),
    eval_declaration(T2, NewENV1, NewENV).


eval_declaration(t_const(T1, T2), ENV, NewENV) :-
    write("assign int "),
    (   T2 = t_digit(Num) % Check if T2 is a numeric literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV),
        update(Id, Num, ENV, NewENV)
    ;   write("ERROR: t_const second argument is not a numeric literal")
    ).

eval_declaration(t_string(T1, T2), ENV, NewENV) :-
    write("assign string "),
    (   T2 = t_string(Str) % Check if T2 is a string literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV1),
        update(Id, Str, ENV, NewENV)
    ;   write("ERROR: t_string second argument is not a string literal")
    ).
eval_declaration(t_bool(T1, T2), ENV, NewENV) :-
    write("assign boolean "),
    (   T2 = t_boolean(Bool) % Check if T2 is a string literal
    ->  eval_num(T1, ENV, Id),
        notContain(Id, ENV),
        add(Id, _, ENV, NewENV1),
        update(Id, Bool, ENV, NewENV)
    ;   write("ERROR: t_bool second argument is not a boolean literal")
    ).

eval_declaration(t_const(T),ENV, NewENV) :- 
    eval_num(T,ENV,Id), 
    write(Id),
    notContain(Id, ENV),
    add(Id,_,ENV, NewENV).


eval_declaration(t_string(T),ENV, NewENV) :- 
    write("test_string"),
    eval_num(T,ENV,Id), 
    notContain(Id, ENV), 
    add(Id,_,ENV, NewENV).

eval_declaration(t_const(_T),ENV, ENV).  
eval_declaration(t_string(_T),ENV, ENV).
eval_declaration(t_bool(_T),ENV, ENV).

eval_num(t_var(X),_ENV,X).
eval_num(t_digit(I),_ENV,I).
eval_num(t_string(S),_ENV,S).

lookup(Id,[(Id,Val)|_], Val).
lookup(Id,[_|T], Val):-lookup(Id,T, Val).
lookup(Id,[],_Val):-write(Id),write(" not exist.").

update(Id, Val, [], [(Id, Val)]).
update(Id, Val, [(Id,_)|T], [(Id, Val)|T]).
update(Id, Val, [H|T], [H|R]) :- H\=(Id,_),update(Id,Val,T,R), write("update3").

notContain(_Id, []).
notContain(Id, [(Id,_)|_]) :-
    throw(duplicate_variable_name(Id)).
notContain(Id, [(Id1,_)|T]) :-
    Id \= Id1,
    notContain(Id, T).

add(Id, NewVal,L,[(Id, NewVal)|L]).