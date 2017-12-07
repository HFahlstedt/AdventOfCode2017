-module(day6).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> next_state(input()).

solve_part2() -> [].

first_max(List) -> first_max(lists:max(List), 0, List).

first_max(Max, Index, [Max|_]) -> Index;
first_max(Max, Index, [_|Rest]) -> first_max(Max, Index+1, Rest).

next_state(List) -> 
    Max = lists:max(List), 
    Length = length(List),
    next_state(Max, first_max(List), Max div Length, (Max rem Length) - 1, Length, 0, List).

next_state(_, _, _, _, Length, Length, _) -> [];
next_state(Max, MaxIndex, PerCell, Overlapping, Length, MaxIndex, [Max|Rest]) -> 
    [PerCell|next_state(Max, MaxIndex, PerCell, Overlapping, Length, MaxIndex+1, Rest)];
next_state(Max, MaxIndex, PerCell, Overlapping, Length, Index, [V|Rest]) -> 
    case Overlapping > (Index - MaxIndex - 1) rem (Length+1) of
        true -> [V + PerCell + 1|next_state(Max, MaxIndex, PerCell, Overlapping, Length, Index+1, Rest)];
        _Else -> [V + PerCell|next_state(Max, MaxIndex, PerCell, Overlapping, Length, Index+1, Rest)]
    end.

input() -> [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5].