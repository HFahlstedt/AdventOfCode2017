-module(day3).
-export([solve_part1/1, solve_part2/1]).

% Part one: follow the positive x-axis of values, which has the form (2n-1)^2+n, this gives us at what "radius"
% the wanted value is located, after that we need to find out in which quadrant the value is, and calculate the
% number of steps toreach an x- or y-axis. The total distance is "radius" + distance to an axis.
solve_part1(Input) -> find_radius(1, Input). % 277678

find_radius(N, Max) when (2 * (N+1) - 1) * (2 * (N+1) - 1) + N > Max -> N + find_offset(N, Max, (2 * N - 1) * (2 * N - 1) + N); 
find_radius(N, Max) -> find_radius(N+1, Max).

find_offset(N, Max, Base) when Base + 6 * N < Max -> Max - (Base + 6 * N);
find_offset(N, Max, Base) when Base + 4 * N < Max -> Max - (Base + 4 * N);
find_offset(N, Max, Base) when Base + 2 * N < Max -> Max - (Base + 2 * N);
find_offset(_, Max, Base) -> Max - Base.

% Part two: Create a map with the positions visited, (0, 0) is the starting point, start at the first position 
% outside (0, 0), which is (1, 0), and facing east. Take steps always trying to "turn left" if there is a position 
% not already visited there. Record the steps and calculate values for the new position (to avoid a lot of 
% conditional code add all eight of the surounding positions, returning default 0 if position not visited). Keep 
% moving until the value is greater than the input.
solve_part2(Input) -> next_step(e, {1, 0}, maps:from_list([{{0, 0}, 1}, {{1, 0}, 1}]), 1, Input).

next_step(_Dir, _Pos, _Visited, Value, Max) when Value > Max -> Value; 
next_step(e, {X, Y}, Visited, _, Max) -> 
    North = {X, Y+1},
    case maps:is_key(North, Visited) of
        false -> 
            Value = calc_value(North, Visited),
            next_step(n, North, maps:put(North, Value, Visited), Value, Max);
        true -> 
            East = {X+1, Y},
            Value = calc_value(East, Visited),
            next_step(e, East, maps:put(East, Value, Visited), Value, Max)
    end;

next_step(n, {X, Y}, Visited, _, Max) -> 
    West = {X-1, Y},
    case maps:is_key(West, Visited) of
        false -> 
            Value = calc_value(West, Visited),
            next_step(w, West, maps:put(West, Value, Visited), Value, Max);
        true -> 
            North = {X, Y+1},
            Value = calc_value(North, Visited),
            next_step(n, North, maps:put(North, Value, Visited), Value, Max)
    end;

next_step(w, {X, Y}, Visited, _, Max) -> 
    South = {X, Y-1},
    case maps:is_key(South, Visited) of
        false -> 
            Value = calc_value(South, Visited),
            next_step(s, South, maps:put(South, Value, Visited), Value, Max);
        true -> 
            West = {X-1, Y},
            Value = calc_value(West, Visited),
            next_step(w, West, maps:put(West, Value, Visited), Value, Max)
    end;

next_step(s, {X, Y}, Visited, _, Max) -> 
    East = {X+1, Y},
    case maps:is_key(East, Visited) of
        false -> 
            Value = calc_value(East, Visited),
            next_step(e, East, maps:put(East, Value, Visited), Value, Max);
        true -> 
            South = {X, Y-1},
            Value = calc_value(South, Visited),
            next_step(s, South, maps:put(South, Value, Visited), Value, Max)
    end.


calc_value({X, Y}, Visited) -> 
    maps:get({X-1, Y+1}, Visited, 0) + maps:get({X, Y+1}, Visited, 0) + maps:get({X+1, Y+1}, Visited, 0) +
    maps:get({X-1, Y}, Visited, 0) +                                    maps:get({X+1, Y}, Visited, 0) +
    maps:get({X-1, Y-1}, Visited, 0) + maps:get({X, Y-1}, Visited, 0) + maps:get({X+1, Y-1}, Visited, 0).