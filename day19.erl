-module(day19).
-export([solve_part1/0, solve_part2/0]).

solve_part1()-> element(1, step({40, 1}, input(), [], down, 0)).
solve_part2()-> element(2, step({40, 1}, input(), [], down, 0)).

step(C, Maze, Letters, Direction, Steps) ->
    case get_symbol(C, Maze) of
        32 -> {Letters, Steps};        
        $| -> step(next(C, Direction), Maze, Letters, Direction, Steps+1);
        $- -> step(next(C, Direction), Maze, Letters, Direction, Steps+1);
        $+ -> step(next(C, turn(C, Direction, Maze)), Maze, Letters, turn(C, Direction, Maze), Steps+1);
        Lt -> step(next(C, Direction), Maze, Letters ++ [Lt], Direction, Steps+1)
    end.

next({X, Y}, down) -> {X, Y+1};
next({X, Y}, up) -> {X, Y-1};
next({X, Y}, left) -> {X-1, Y};
next({X, Y}, right) -> {X+1, Y}.

turn_right(down) -> left;
turn_right(up) -> right;
turn_right(left) -> up;
turn_right(right) -> down.

turn_left(down) -> right;
turn_left(up) -> left;
turn_left(left) -> down;
turn_left(right) -> up.

get_symbol({X, Y}, Maze) -> lists:nth(X, lists:nth(Y, Maze)).

turn(C, Direction, Maze) -> 
    case get_symbol(next(C, turn_right(Direction)), Maze) of
        32 -> turn_left(Direction);
        _ -> turn_right(Direction)
    end.

input() -> utils:read_lines("day19.txt").
