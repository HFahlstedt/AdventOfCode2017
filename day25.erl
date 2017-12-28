-module(day25).
-export([solve_part1/0]).

solve_part1() -> execute(a, 0, 0, maps:new(), 12368930).

execute(_, _, _, Tape, 0) -> lists:sum(maps:values(Tape));
execute(a, 0, Pos, Tape, Count) -> execute(b, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1);
execute(a, 1, Pos, Tape, Count) -> execute(c, read(right(Pos), Tape), right(Pos), write(Pos, 0, Tape), Count-1);
execute(b, 0, Pos, Tape, Count) -> execute(a, read(left(Pos),  Tape),  left(Pos), write(Pos, 0, Tape), Count-1);
execute(b, 1, Pos, Tape, Count) -> execute(d, read(right(Pos), Tape), right(Pos), write(Pos, 0, Tape), Count-1);
execute(c, 0, Pos, Tape, Count) -> execute(d, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1);
execute(c, 1, Pos, Tape, Count) -> execute(a, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1);
execute(d, 0, Pos, Tape, Count) -> execute(e, read(left(Pos),  Tape),  left(Pos), write(Pos, 1, Tape), Count-1);
execute(d, 1, Pos, Tape, Count) -> execute(d, read(left(Pos),  Tape),  left(Pos), write(Pos, 0, Tape), Count-1);
execute(e, 0, Pos, Tape, Count) -> execute(f, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1);
execute(e, 1, Pos, Tape, Count) -> execute(b, read(left(Pos),  Tape),  left(Pos), write(Pos, 1, Tape), Count-1);
execute(f, 0, Pos, Tape, Count) -> execute(a, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1);
execute(f, 1, Pos, Tape, Count) -> execute(e, read(right(Pos), Tape), right(Pos), write(Pos, 1, Tape), Count-1).


read(Pos, Tape) -> maps:get(Pos, Tape, 0).

write(Pos, Val, Tape) -> maps:put(Pos, Val, Tape). 

left(Pos) -> Pos - 1.

right(Pos) -> Pos + 1.