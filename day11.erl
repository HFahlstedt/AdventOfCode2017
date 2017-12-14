-module(day11).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> move(input(), {0, 0}, 0).
solve_part2() -> move(input(), {0, 0}, 0).

move([], {X, Y}, Max) -> {{X, Y}, abs(X/5) + abs((Y-X)/10), Max};
move([n|Rest], {X, Y}, Max) -> move(Rest, {X, Y+10}, max(abs(X/5) + abs((Y-X)/10), Max));
move([ne|Rest], {X, Y}, Max) -> move(Rest, {X+5, Y+5}, max(abs(X/5) + abs((Y-X)/10), Max));
move([se|Rest], {X, Y}, Max) -> move(Rest, {X+5, Y-5}, max(abs(X/5) + abs((Y-X)/10), Max));
move([s|Rest], {X, Y}, Max) -> move(Rest, {X, Y-10}, max(abs(X/5) + abs((Y-X)/10), Max));
move([sw|Rest], {X, Y}, Max) -> move(Rest, {X-5, Y-5}, max(abs(X/5) + abs((Y-X)/10), Max));
move([nw|Rest], {X, Y}, Max) -> move(Rest, {X-5, Y+5}, max(abs(X/5) + abs((Y-X)/10), Max)).

input() -> lists:map(fun(X) -> list_to_atom(X) end, string:tokens(utils:read_textfile("day11.txt"), ",")).
