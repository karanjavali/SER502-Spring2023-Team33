%command evaluation
com_eval(t_command(X,Y),Env,NewEnv) :- com1_eval(X,Env,NEnv), com_eval(Y,NEnv,NewEnv).
com_eval(X,Env,Env) :- com1_eval(X,Env,_).

%assignment evaluation
com1_eval(t_assign(X,Y),Env,NewEnv) :- expr_eval(Y,Env,NEnv,Val),
    update(X,NEnv,Val,NewEnv).

%condition evaluation
com1_eval(t_conditional(X,Y,_Z),Env,NewEnv) :- bool_eval(X,Env,Bool),Bool=true,
    com_eval(Y,Env,NewEnv).
com1_eval(t_conditional(X,_Y,Z),Env,NewEnv) :- bool_eval(X,Env,Bool),Bool=false,
    com_eval(Z,Env,NewEnv).
%com1_eval(t_conditional(X,Y,Z), Env, NewEnv) :- com1_eval(X,Env,Env1),
com1_eval(t_ternary(X,Y,_Z),Env,NewEnv) :- bool_eval(X,Env,Bool),Bool=true,
    com_eval(Y,Env,NewEnv).
com1_eval(t_ternary(X,_Y,Z),Env,NewEnv) :- bool_eval(X,Env,Bool),Bool=false,
    com_eval(Z,Env,NewEnv).
com1_eval(t_for_javatype(X,Y,Z),Env,NewEnv) :- com1_eval(X,Env,Env1),com1_eval(Y,Env1,Env2),
    com_eval(Z,Env2,NewEnv).

%evaluate the boolean
bool_eval(true,_Env,true).
bool_eval(false,_Env,false).
bool_eval(t_booleanEquality(X,Y),Env,true) :- expr_eval(X,Env,Env1,Val1),
    expr_eval(Y,Env,Env1,Val2),
    Val1=Val2.
bool_eval(t_booleanEquality(X,Y),Env,false) :- expr_eval(X,Env,Env1,Val1),
    expr_eval(Y,Env,Env1,Val2),
    Val1\=Val2.
bool_eval(t_booleanNotEquality(X),Env,true):- bool_eval(X,Env,Bool), Bool = false.
bool_eval(t_booleanNotEquality(X),Env,false):- bool_eval(X,Env,Bool), Bool = true.

%evaluate the expression
expr_eval(X, Env, Env, Val) :- temp1_eval(X, Env, Env, Val).
expr_eval(t_add(X,Y), Env, NewEnv, Val) :- expr_eval(X, Env, NEnv,V1),
    temp1_eval(Y, NEnv, NewEnv,V2), Val is V1 + V2.
expr_eval(t_sub(X,Y), Env, NewEnv, Val) :- expr_eval(X, Env, NEnv,V1), 
    temp1_eval(Y, NEnv, NewEnv,V2), Val is V1 - V2.

%evaluate temp1 expression
temp1_eval(T,Env,Env,Val) :- temp2_eval(T,Env,Env,Val).
temp1_eval(t_multiply(X,Y), Env, NewEnv, Val) :- temp1_eval(X, Env, NEnv,Val1),
    temp2_eval(Y,NEnv,NewEnv,Val2),Val is Val1 * Val2.
temp1_eval(t_divide(X,Y), Env, NewEnv, Val) :- temp1_eval(X, Env, NEnv,Val1),
    temp2_eval(Y,NEnv,NewEnv,Val2),Val is Val1 / Val2.

%evaluate temp2 expression
temp2_eval(t_parenthesis(X),Env,NewEnv,Val) :- expr_eval(X,Env,NewEnv,Val).
temp2_eval(t_assign(X,Y),Env,NewEnv,Val) :- expr_eval(Y,Env,NEnv,Val),
    update(X,NEnv,Val,NewEnv).

%update environment
update(V,[],NewVal,[(V,NewVal)]).
update(V,[(V,_)|T],NewVal,[(V,NewVal)|T]).
update(V,[H|T],NewVal,[H|NewEnv]):-update(V,T,NewVal,NewEnv).

%look up value of V from environment
lookup(V,[(V,Val)|_],Val).
lookup(V,[_|T],Val):-lookup(V,T,Val).