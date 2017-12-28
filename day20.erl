-module(day20).
-export([solve_part1/0, solve_part2/0]).
-define(Steps, 100).

solve_part1() -> hd(hd(lists:sort(fun([_, _, _, {X1, Y1, Z1}], [_, _, _, {X2, Y2, Z2}]) -> abs(X1) + abs(Y1) + abs(Z1) < abs(X2) + abs(Y2) + abs(Z2) end, input()))).
solve_part2() -> 1000 - length(find_collisions(input(), input(), sets:new())).

will_collide(_, _, Max, Max) -> -1;
will_collide({P1, _, _}, {P1, _, _}, Steps, _) -> Steps;
will_collide({P1, V1, A1}, {P2, V2, A2}, Steps, Max) -> will_collide({P1+V1+A1, V1+A1, A1}, {P2+V2+A2, V2+A2, A2}, Steps+1, Max).

collides([_, {P1_X, P1_Y, P1_Z}, {P1_VX, P1_VY, P1_VZ}, {P1_AX, P1_AY, P1_AZ}], [_, {P2_X, P2_Y, P2_Z}, {P2_VX, P2_VY, P2_VZ}, {P2_AX, P2_AY, P2_AZ}]) ->
    CX = will_collide({P1_X, P1_VX, P1_AX}, {P2_X, P2_VX, P2_AX}, 0, ?Steps),
    if 
        CX == -1 -> false;
        true -> 
            (CX == will_collide({P1_Y, P1_VY, P1_AY}, {P2_Y, P2_VY, P2_AY}, 0, ?Steps)) and
            (CX == will_collide({P1_Z, P1_VZ, P1_AZ}, {P2_Z, P2_VZ, P2_AZ}, 0, ?Steps))
    end.

find_collisions([], _, Found) -> sets:to_list(Found);
find_collisions([P|Rest], All, Found) ->
    C = lists:filter(fun(X) -> collides(P, X) end, Rest),
    if
        length(C) > 0 -> find_collisions(Rest, All, sets:union([sets:from_list([P]), Found, sets:from_list(C)]));
        true -> find_collisions(Rest, All, sets:union([Found, sets:from_list(C)]))
    end.

input() -> 
    Lines = utils:read_lines("day20.txt"),
    lists:map(fun(X) -> parse_input(X) end, lists:zip(lists:seq(0, length(Lines)-1), Lines)).

parse_input({Index, Data}) -> 
    {match, Matches} = 
        re:run(Data, "p=<(-?\\d+),(-?\\d+),(-?\\d+)>, v=<(-?\\d+),(-?\\d+),(-?\\d+)>, a=<(-?\\d+),(-?\\d+),(-?\\d+)>" , [{capture, all_but_first, list}]),
        [X, Y, Z, VX, VY, VZ, AX, AY, AZ] = lists:map(fun list_to_integer/1, Matches),
    [integer_to_list(Index), {X, Y, Z}, {VX, VY, VZ}, {AX, AY, AZ}].
