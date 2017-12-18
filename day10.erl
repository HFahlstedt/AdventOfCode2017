-module(day10).
-export([solve_part1/0, solve_part2/0, knot_hash/1]).
-define(Size, 256).

solve_part1() -> 
    {[First, Second|_], _, _} = solve(lists:seq(0, ?Size - 1), 0, 0, input()),
    First * Second.

solve_part2() -> lists:flatten(lists:map(fun(X) -> string:to_lower(string:right("0" ++ integer_to_list(X, 16), 2)) end, knot_hash(input_as_string()))).

knot_hash(String) -> dense(solve2(63, solve(lists:seq(0, 255), 0, 0, String ++ [17, 31, 73, 47, 23]), String ++ [17, 31, 73, 47, 23])).

solve(State, Pos, Skip, []) -> {State, Pos, Skip};
solve(State, Pos, Skip, [Length|Rest]) ->
    Rotated = utils:rotate_list_l(State, Pos),
    NewState = utils:rotate_list_r(lists:reverse(lists:sublist(Rotated, 1, Length)) ++ lists:nthtail(Length, Rotated), Pos),
    solve(NewState, (Pos + Length + Skip) rem ?Size, Skip+1, Rest).

solve2(0, {LState, _LPos, _LSkip}, _Input) -> LState;
solve2(Rounds, {LState, LPos, LSkip}, Input) -> 
    New = solve(LState, LPos, LSkip, Input),
    solve2(Rounds-1, New, Input).

dense([]) -> [];
dense(List) -> {L1, L2} = lists:split(16, List), [lists:foldl(fun(X, Agg) -> X bxor Agg end, 0, L1)|dense(L2)].

input() -> lists:map(fun(X) -> list_to_integer(X) end, string:tokens(input_as_string(), ",")).
input_as_string() -> utils:read_textfile("day10.txt").