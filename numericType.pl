:- table integer/3.
:- table non_zero_digit/3.
:- table digits/3.
:- table digit/3.
:- use_rendering(svgtree).

integer(t_integer(D)) --> digit(D).
integer(t_integer(N,D)) --> non_zero_digit(N), digits(D).
integer(t_integer(S,[N|D])) --> sign(S), non_zero_digit(N), digits(D).

digit(0) --> [0].
digit(t_digit(D)) --> non_zero_digit(D).

sign(t_sign(+)) --> [+].
sign(t_sign(-)) --> [-].

non_zero_digit(1) --> [1].
non_zero_digit(2) --> [2].
non_zero_digit(3) --> [3].
non_zero_digit(4) --> [4].
non_zero_digit(5) --> [5].
non_zero_digit(6) --> [6].
non_zero_digit(7) --> [7].
non_zero_digit(8) --> [8].
non_zero_digit(9) --> [9].

digits(t_digits(D)) --> digit(D).
digits(t_digits(N,D)) --> non_zero_digit(N), digits(D).