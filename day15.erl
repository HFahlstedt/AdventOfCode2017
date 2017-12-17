-module(day15).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> solve_part1(512, 191).
solve_part1(A, B) -> solve(40000000, 0, A, B, 1, 1).

solve_part2() -> solve_part2(512, 191).
solve_part2(A, B) -> solve(5000000, 0, A, B, 4, 8). % 512, 191

solve(0, Sum, _, _, _, _) -> Sum;
solve(Count, Sum, PrevA, PrevB, CheckA, CheckB) ->
    NextA = next(PrevA, 16807, CheckA),
    NextB = next(PrevB, 48271, CheckB),
    case judge(NextA, NextB) of
        true -> solve(Count-1, Sum+1, NextA, NextB, CheckA, CheckB);
        _Else -> solve(Count-1, Sum, NextA, NextB, CheckA, CheckB)
    end.

judge(A, B) -> (A band 16#FFFF) bxor (B band 16#FFFF) == 0.

next(Prev, Multipler, Check) ->
    Next = (Prev * Multipler) rem 2147483647,
    case Next rem Check of
        0 -> Next;
        _ -> next(Next, Multipler, Check)
    end.
