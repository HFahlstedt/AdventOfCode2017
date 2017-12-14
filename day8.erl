-module(day8).
-export([solve_part1/0, solve_part2/0]).

% Same solution for both parts, just step through the list of operations and execute them, store registers in a map, and 
% keep track of the highest value stored during the process
solve_part1() -> {{_, V}, _} = solve(input(), maps:new(), 0), V.
solve_part2() -> {{_, _}, Max} = solve(input(), maps:new(), 0), Max.

solve([], Registers, Highest) -> {hd(lists:sort(fun({_, V}, {_, V2}) -> V > V2 end, maps:to_list(Registers))), Highest};
solve([{R1, Op, V1, R2, Cmp, V2}|Instructions], Registers, Highest) -> 
    case compare(maps:get(R2, Registers, 0), V2, Cmp) of 
        true -> 
            NewVal = new_value(maps:get(R1, Registers, 0), V1, Op),
            solve(Instructions, maps:put(R1, NewVal, Registers), max(NewVal, Highest));
        _Else -> solve(Instructions, Registers, Highest)
    end.

new_value(R, V, inc) -> R + V;
new_value(R, V, dec) -> R - V.

compare(Val1, Val2, "!=") -> Val1 /= Val2;
compare(Val1, Val2, "==") -> Val1 == Val2;
compare(Val1, Val2, ">") -> Val1 > Val2;
compare(Val1, Val2, "<") -> Val1 < Val2;
compare(Val1, Val2, ">=") -> Val1 >= Val2;
compare(Val1, Val2, "<=") -> Val1 =< Val2.

input() -> lists:map(
	fun(X) -> 
		{match, [R1, Op, V1, R2, Cmp, V2]} = re:run(X, "([a-z]+) (inc|dec) (-?\\d+) if ([a-z]+) ([!<>=]+) (-?\\d+)", [{capture, all_but_first, list}]),
		{list_to_atom(R1), list_to_atom(Op), list_to_integer(V1), list_to_atom(R2), Cmp, list_to_integer(V2)}
	end, 
	utils:read_lines("day8.txt")).
