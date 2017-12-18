-module(day1).
-export([solve_part1/0, solve_part2/0]).

% Same solution for both parts, compare the original list witha a copy rotated N steps to the right. In part one N = 1 and in
% part two N = length of input list / 2. 

solve_part1() -> solve(input(), utils:rotate_list_r(input(), 1), 0).

solve_part2() -> solve(input(), utils:rotate_list_r(input(), round(length(input()) / 2)), 0).

solve([], [], Sum) -> Sum;
solve([A|Rest1], [A|Rest2], Sum) -> solve(Rest1, Rest2, Sum + A);
solve([_|Rest1], [_|Rest2], Sum) -> solve(Rest1, Rest2, Sum).

input() -> lists:map(fun(X) -> X - 48 end, utils:read_textfile("day1.txt")).
