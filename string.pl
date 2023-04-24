:- table input_character/3.
:- table escape_character/3.
:- table string_character/3.
:- table string_characters/3.
:- table string/3.
:- use_rendering(svgtree).


string(t_string(S)) --> string_characters(S).

input_character(t_input_character(C)) --> [C].

escape_character(\n) --> [\n].
escape_character(\t) --> [\t].
escape_character(\) --> [\].

string_character(t_string_character(Char)) --> input_character(Char).
string_character(t_string_character(Char)) --> escape_character(Char).

string_characters(t_string_characters(Char)) --> string_character(Char).
string_characters(t_string_characters(Char,Chars)) --> string_character(Char), string_characters(Chars).