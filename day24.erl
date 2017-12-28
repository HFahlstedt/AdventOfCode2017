-module(day24).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> element(2, find_strongest(0, input(), [], 0)).
solve_part2() -> element(2, find_longest(0, input(), [], 0)).

find_ports(_, []) -> [];
find_ports(X, [P = {X, _}|Rest]) -> [P|find_ports(X, Rest)];
find_ports(X, [P = {_, X}|Rest]) -> [P|find_ports(X, Rest)];
find_ports(X, [_|Rest]) -> find_ports(X, Rest).

other({X, Y}, X) -> Y;
other({X, Y}, Y) -> X.

strength({A, B}) -> A + B.

find_strongest(Start, List, Acc, Strength) ->
    case find_ports(Start, List) of
        [] -> {Acc, Strength};
        Possible -> 
            Bridges = lists:map(fun(C) -> find_strongest(other(C, Start), lists:delete(C, List), Acc ++ [C], Strength + strength(C)) end, Possible),
            hd(lists:sort(fun({_, S1}, {_, S2}) -> S1 > S2 end, Bridges))
    end.

find_longest(Start, List, Acc, Strength) ->
    case find_ports(Start, List) of
        [] -> {Acc, Strength};
        Possible -> 
            Bridges = lists:map(fun(C) -> find_longest(other(C, Start), lists:delete(C, List), Acc ++ [C], Strength + strength(C)) end, Possible),
            hd(lists:sort(fun({B1, S1}, {B2, S2}) -> if length(B1) == length(B2) -> S1 > S2; true -> length(B1) > length(B2) end end, Bridges))
    end.

input() -> lists:map(fun(L) -> list_to_tuple(lists:map(fun list_to_integer/1, string:tokens(L, "/"))) end, utils:read_lines("day24.txt")).
