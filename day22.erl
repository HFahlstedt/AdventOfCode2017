-module(day22).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> burst({0, 0}, up, initial(), 0, 10000).
solve_part2() -> burst2({0, 0}, up, initial(), 0, 10000000).

burst(_, _, _, Count, 0) -> Count;
burst(Pos, Direction, State, Count, N) ->
    case maps:get(Pos, State, clean) of
        clean -> burst(next_pos(Pos, turn_left(Direction)), turn_left(Direction), maps:put(Pos, infected, State), Count + 1, N - 1);
        infected -> burst(next_pos(Pos, turn_right(Direction)), turn_right(Direction), maps:put(Pos, clean, State), Count, N - 1)
    end.


burst2(_, _, _, Count, 0) -> Count;
burst2(Pos, Direction, State, Count, N) ->
    case maps:get(Pos, State, clean) of
        clean -> burst2(next_pos(Pos, turn_left(Direction)), turn_left(Direction), maps:put(Pos, weakened, State), Count, N - 1);
        infected -> burst2(next_pos(Pos, turn_right(Direction)), turn_right(Direction), maps:put(Pos, flagged, State), Count, N - 1);
        weakened -> burst2(next_pos(Pos, Direction), Direction, maps:put(Pos, infected, State), Count + 1, N - 1);
        flagged -> burst2(next_pos(Pos, reverse(Direction)), reverse(Direction), maps:put(Pos, clean, State), Count, N - 1)
    end.

next_pos({X, Y}, up) -> {X, Y+1};
next_pos({X, Y}, down) -> {X, Y-1};
next_pos({X, Y}, right) -> {X+1, Y};
next_pos({X, Y}, left) -> {X-1, Y}.

turn_left(up) -> left;
turn_left(down) -> right;
turn_left(left) -> down;
turn_left(right) -> up.

turn_right(up) -> right;
turn_right(down) -> left;
turn_right(left) -> up;
turn_right(right) -> down.

reverse(up) -> down;
reverse(down) -> up;
reverse(left) -> right;
reverse(right) -> left.

initial() -> convert(input(), {-length(hd(input())) div 2, length(input()) div 2}, maps:new()).

convert([], _, Map) -> Map;
convert([[]|Rest], {_, Y}, Map) -> convert(Rest, {-length(hd(input())) div 2, Y-1}, Map);
convert([[$.|RestOfLine]|Rest], {X, Y}, Map) -> convert([RestOfLine|Rest], {X+1, Y}, maps:put({X, Y}, clean, Map));
convert([[$#|RestOfLine]|Rest], {X, Y}, Map) -> convert([RestOfLine|Rest], {X+1, Y}, maps:put({X, Y}, infected, Map)).

input() -> utils:read_lines("day22.txt").