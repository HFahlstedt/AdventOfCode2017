-module(day7).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> find_root(input_map(), element(1, hd(input()))).

solve_part2() -> 
    Root = solve_part1(), 
    {{Name, W}, Diff} = select_faulty_tower(node_weights(Root)),
    solve(Name, W, Diff).


find_root(Map, Current) -> 
    Search = maps:filter(fun(_, {_, Above}) -> lists:member(Current, Above) end, Map),
    case maps:size(Search) of
        0 -> Current;
        _ -> find_root(Map, element(1, hd(maps:to_list(Search))))
    end.

node_weights(Name) -> lists:map(fun(NodeName) -> {NodeName, node_weight(maps:get(NodeName, input_map()))} end, element(2, maps:get(Name, input_map()))).

node_weight({Weight, Above}) -> Weight + lists:sum(lists:map(fun(AboveKey) -> node_weight(maps:get(AboveKey, input_map())) end, Above)).

select_faulty_tower(Nodes) -> 
    Sorted = lists:sort(fun({_, W1}, {_, W2}) -> W1 < W2 end, Nodes), 
    case element(2, hd(Sorted)) == element(2, hd(tl(Sorted))) of
        true -> Last = lists:last(Sorted), {Last, element(2, Last) - element(2, hd(Sorted))};
        _Else -> {hd(Sorted), element(2, hd(Sorted)) - element(2, hd(tl(Sorted)))}
    end.

solve(Name, LastWeight, Diff) -> 
    case select_faulty_tower(node_weights(Name)) of
        {{_, _}, 0} -> LastWeight - Diff;
        {{X, _}, Diff} -> solve(X, element(1, maps:get(X, input_map())), Diff)
    end.

input_map() -> maps:from_list(input()).

input() -> 
    lists:map(fun(X) -> parse_input(string:tokens(X, "->")) end, utils:read_lines("day7.txt")).

parse_input([A|B]) -> 
    {match, [NameStr, WeightStr]} = re:run(A, "([a-z]+) \\((\\d+)\\)", [{capture, [1, 2], list}]),
    Name = list_to_atom(NameStr),
    Weight = list_to_integer(WeightStr),
    List = 
        case B of
            [] -> [];
            [Tokens] -> lists:map(fun(X) -> list_to_atom(X) end, string:tokens(Tokens, ", "))
        end,
    {Name, {Weight, List}}.
