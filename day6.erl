-module(day6).
-export([solve_part1/0, solve_part2/0]).

% Same solution for both parts, the difference is only in the input value, the input for part two is calculated in part one.
% The first part gives the input for part two.
% Calculate the next state by setting maximum to zero, adding Max div 16 to all cells and then adding one extra for the
% Max mod 16 cells after maximum.

solve_part1() -> solve(input()).

solve_part2() -> {_, LoopStart} = solve_part1(), solve(LoopStart).

solve(State) -> solve(State, sets:from_list([State])).

solve(State, Previous) -> 
    Next = next_state(0, first_max(State), lists:max(State), State),
    case sets:is_element(Next, Previous) of 
        true -> {sets:size(Previous), Next};
        _Else -> solve(Next, sets:add_element(Next, Previous))
    end.

first_max(List) -> first_max(lists:max(List), 0, List).

first_max(Max, Index, [Max|_]) -> Index;
first_max(Max, Index, [_|Rest]) -> first_max(Max, Index+1, Rest).

next_state(_, _, _, []) -> [];
next_state(MaxIndex, MaxIndex, Max, [_|Rest]) -> [Max div 16|next_state(MaxIndex+1, MaxIndex, Max, Rest)];
next_state(Index, MaxIndex, Max, [Val|Rest]) -> 
    case mod(Index - MaxIndex - 1, 16) < mod(Max-16, 16) of 
        true -> [Val + (Max div 16) + 1|next_state(Index+1, MaxIndex, Max, Rest)];
        _Else -> [Val + Max div 16|next_state(Index+1, MaxIndex, Max, Rest)]
    end.

mod(N, D) when N rem D < 0 -> N rem D + D;
mod(N, D) -> N rem D.

input() -> [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5].