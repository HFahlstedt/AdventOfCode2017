-module(day12).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> sets:size(find_group(0, maps:from_list(input()))).
solve_part2() -> find_all_groups(input(), 0).

find_group(Id, All) -> sets:from_list(solve(maps:get(Id, All), maps:without([Id], All))).

find_all_groups([], Count) -> Count;
find_all_groups(List, Count) -> 
    {Id, _} = hd(List),
    All = maps:from_list(List), 
    Group = find_group(Id, All),
    find_all_groups(maps:to_list(maps:without(sets:to_list(Group), All)), Count+1).

solve([], _) -> [];
solve([Id|Rest], All) -> [Id] ++ maps:get(Id, All, []) ++ solve(maps:get(Id, All, []), maps:without([Id], All)) ++ solve(Rest, maps:without([Id], All)).

input() -> lists:map(
	fun(Line) -> 
		{match, [Id|[Conns]]} = re:run(Line, "(\\d+) <-> ([0-9, ]+)", [{capture, all_but_first, list}]),
		{list_to_integer(Id), lists:map(fun(C) -> list_to_integer(C) end, string:tokens(Conns, ", "))}
	end, 
	utils:read_lines("day12.txt")).
