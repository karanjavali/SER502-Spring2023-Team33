program(P,[begin, int, x, := , 5, ;, int, y, ;, bool, z,  ;, y, :=, 7, ;, if, x, '>', y, then, z, :=, true, else, z, :=, false, endif, end, .],[]),write(P),program_eval(P,Z).
