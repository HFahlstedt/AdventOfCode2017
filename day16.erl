-module(day16).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> queue:to_list(dance(input(), initial_state())).

solve_part2() -> 
    Cycle = find_cycle(initial_state(), [lists:seq($a, $p)]),
    lists:nth(1000000000 rem length(Cycle) + 1, Cycle).

dance([], State) -> State;
dance([{s, N}|Rest], State) -> dance(Rest, spin(N, State));
dance([{x, P1, P2}|Rest], State) -> dance(Rest, exchange(P1, P2, State));
dance([{p, Pr1, Pr2}|Rest], State) -> dance(Rest, partner(Pr1, Pr2, State)).

initial_state() -> queue:from_list(lists:seq($a, $p)).

spin(0, State) -> State;
spin(N, State) -> spin(N-1, queue:in_r(queue:last(State), queue:drop_r(State))).

exchange(Pos1, Pos2, State) -> 
    {A, X} = queue:split(min(Pos1, Pos2), State),
    {B, C} = queue:split(max(Pos1, Pos2)-min(Pos1, Pos2), X),    
    queue:join(A, queue:join(queue:in_r(queue:head(C), queue:tail(B)), queue:in_r(queue:head(B), queue:tail(C)))).

partner(Pr1, Pr2, State) -> exchange(pos(Pr1, State), pos(Pr2, State), State).

pos(Pr, State) -> pos(0, Pr, State).

pos(Pos, Pr, State) -> 
    case queue:head(State) == Pr of
        true -> Pos;
        _ -> pos(Pos+1, Pr, queue:tail(State))
    end.

find_cycle(State, Previous) -> 
    NewState = dance(input(), State),
    case queue:to_list(NewState) of
        "abcdefghijklmnop" -> Previous;
        L -> find_cycle(NewState, Previous ++ [L])
    end.

input() -> lists:map(fun(I) -> parse_input(I) end, string:tokens(utils:read_textfile("day16.txt"), ",")). 

parse_input(I) ->
    case re:run(I, "s(\\d+)", [{capture, [1], list}]) of
        {match, [N]} -> {s, list_to_integer(N)};
        nomatch ->  
            case re:run(I, "x(\\d+)/(\\d+)", [{capture, [1, 2], list}]) of
                {match, [Pos1, Pos2]} -> {x, list_to_integer(Pos1), list_to_integer(Pos2)};
                nomatch -> 
                    {match, [Pr1, Pr2]} = re:run(I, "p(.)/(.)", [{capture, [1, 2], list}]),
                    {p, hd(Pr1), hd(Pr2)}
            end
    end.
