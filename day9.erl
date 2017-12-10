-module(day9).
-export([solve_part1/0, solve_part2/0]).


solve_part1() -> parse_groups(remove_garbage(remove_canceled(input()), outside), 1).
solve_part2() -> parse_garbage(remove_canceled(input()), 0, not_counting).

parse_groups([], _) -> 0;
parse_groups([125|Rest], Value) -> parse_groups(Rest, Value - 1); % }
parse_groups([123|Rest], Value) -> Value + parse_groups(Rest, Value + 1); % {
parse_groups([_|Rest], Value) -> parse_groups(Rest, Value).

parse_garbage([], Count, _) -> Count;
parse_garbage([62|Rest], Count, _) -> parse_garbage(Rest, Count, not_counting);
parse_garbage([60|Rest], Count, not_counting) -> parse_garbage(Rest, Count, counting);  
parse_garbage([_|Rest], Count, counting) -> parse_garbage(Rest, Count+1, counting);
parse_garbage([_|Rest], Count, not_counting) -> parse_garbage(Rest, Count, not_counting).

remove_garbage([], _) -> [];
remove_garbage([60|Rest], in) -> remove_garbage(Rest, in);
remove_garbage([60|Rest], _) -> remove_garbage(Rest, in);
remove_garbage([62|Rest], _) -> remove_garbage(Rest, outside);
remove_garbage([_|Rest], in) -> remove_garbage(Rest, in);
remove_garbage([X|Rest], _) -> [X|remove_garbage(Rest, outside)].

remove_canceled([]) -> [];
remove_canceled([33,_|Rest]) -> remove_canceled(Rest);
remove_canceled([X|Rest]) -> [X|remove_canceled(Rest)].

input() -> utils:read_textfile("day9.txt").
