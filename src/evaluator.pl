program_eval(t_program(X), Result) :-
    eval_block(X, [], Result).

eval_block(t_block(T1), ENV, Result) :-
    eval_declaration(T1, ENV, NewENV).
    %eval_command(T2, NewENV, NewENV1),
	lookup(z,NewENV,Result).

eval_declaration(t_declare(T1, T2),ENV,NewENV) :- 
    eval_declaration(T1, ENV, NewENV1),
    eval_declaration(T2, NewENV1, NewENV).

eval_declaration(t_const(T),ENV, NewENV) :- 
    eval_num(T,ENV,Id), 
    notContain(Id, ENV), 
    add(Id,_,ENV, NewENV).

eval_declaration(t_const(T1, T2), ENV, NewENV) :- eval_num(T1,ENV,Id), eval_num(T2,ENV,Num), update(Id,Num,ENV,NewENV).
eval_declaration(t_string(T1, T2), ENV, NewENV) :- eval_num(T1,ENV,Id), eval_num(T2,ENV,Num), update(Id,Num,ENV,NewENV).
eval_declaration(t_bool(T1, T2), ENV, NewENV) :- eval_num(T1,ENV,Id), eval_num(T2,ENV,Num), update(Id,Num,ENV,NewENV).

eval_declaration(t_const(_T),ENV, ENV).   
eval_declaration(t_string(_T),ENV, ENV).
eval_declaration(t_bool(_T),ENV, ENV).

eval_num(t_var(X),_PAR, X).
eval_num(t_digit(I),_PAR,I).
eval_num(t_string(I),_PAR,I).

add(K, PAR,L,[(K, PAR)|L]).

lookup(K,[(K,INT)|_], INT).
lookup(K,[_|T], INT):-lookup(K,T, INT).

update(K, INT, [], [(K, INT)]).
update(K, INT, [(K,_)|T], [(K, INT)|T]).
update(K, INT, [H|L], [H|B]) :- H\=(K,_),update(K,INT,L,B).

notContain(_Id,[]).
notContain(Id,[(Id1,_)|T]):- Id\=Id1, notContain(Id,T).