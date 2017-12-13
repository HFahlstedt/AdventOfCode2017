-module(day13).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> lists:foldl(fun({L, D}, Sum) -> L * D + Sum end, 0, solve(input(), 0, [], 0)).
solve_part2() -> solve2(10).

solve([], _, Caught, _) -> Caught;
solve([{T, D}|Rest], T, Caught, Delay) -> 
    case scan_pos(T + Delay, D) of  
        0 -> solve(Rest, T+1, Caught ++ [{T, D}], Delay);
        _Else -> solve(Rest, T+1, Caught, Delay)
    end;
solve([{L, D}|Rest], T, Caught, Delay) -> solve([{L, D}|Rest], T+1, Caught, Delay).

solve2(Delay) -> 
    case solve(input(), 0, [], Delay) of
        [] -> Delay;
        _Else -> solve2(Delay+1)
    end.

scan_pos(T, Depth) -> lists:nth(T rem (2*(Depth-1)) + 1, lists:seq(0, Depth-1) ++ lists:seq(Depth-2, 1, -1)).

input() -> lists:map(
    fun(X) -> 
        [L, D] = string:tokens(X, ": "), 
        {list_to_integer(L), list_to_integer(D)} 
    end, 
    utils:read_lines("day13.txt")).
