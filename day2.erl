-module(day2).
-export([solve_part1/0, solve_part2/0]).

% Part one: Map a function calculating the difference between the largest and smallest value of each row,
% then summarize the values.
solve_part1() -> lists:sum(lists:map(fun(L) -> lists:max(L) - lists:min(L) end, input())).

% Part two: Map a function that first sorts the row and then finds the sum of all numbers that has a divisor 
% in the same row, the summarize the values.
solve_part2() -> lists:sum(lists:map(fun(L) -> solve(lists:sort(L), 0) end, input())).

solve([], Sum) -> Sum;
solve([E|Rest], Sum) -> solve(Rest, Sum + sum_of_divides(E, Rest, 0)).

sum_of_divides(_, [], Sum) -> Sum;
sum_of_divides(E, [X|List], Sum) when X rem E == 0 -> sum_of_divides(E, List, Sum + (X div E));
sum_of_divides(E, [_|List], Sum) -> sum_of_divides(E, List, Sum).

input() -> 
    lists:map(
        fun(X) -> lists:map(fun(Y) -> list_to_integer(Y) end, string:tokens(X, "\t")) end, 
        string:tokens(utils:read_textfile("day2.txt"), "\r\n")).
