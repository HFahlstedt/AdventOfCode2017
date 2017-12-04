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
next_step(Direction, Position, Visited, _, Max) -> 
    Left = left_turn(Direction, Position),
    case maps:is_key(Left, Visited) of
        false -> 
            Value = calc_value(Left, Visited),
            next_step(left_direction(Direction), Left, maps:put(Left, Value, Visited), Value, Max);
        true -> 
            Straight = straight_ahead(Direction, Position),
            Value = calc_value(Straight, Visited),
            next_step(Direction, Straight, maps:put(Straight, Value, Visited), Value, Max)
    end.

left_turn(e, {X, Y}) -> {X, Y+1};
left_turn(n, {X, Y}) -> {X-1, Y};
left_turn(w, {X, Y}) -> {X, Y-1};
left_turn(s, {X, Y}) -> {X+1, Y}.

left_direction(e) -> n;
left_direction(n) -> w;
left_direction(w) -> s;
left_direction(s) -> e.

straight_ahead(e, {X, Y}) -> {X+1, Y};
straight_ahead(n, {X, Y}) -> {X, Y+1};
straight_ahead(w, {X, Y}) -> {X-1, Y};
straight_ahead(s, {X, Y}) -> {X, Y-1}.

calc_value({X, Y}, Visited) -> 
    maps:get({X-1, Y+1}, Visited, 0) + maps:get({X, Y+1}, Visited, 0) + maps:get({X+1, Y+1}, Visited, 0) +
    maps:get({X-1, Y}, Visited, 0) +                                    maps:get({X+1, Y}, Visited, 0) +
    maps:get({X-1, Y-1}, Visited, 0) + maps:get({X, Y-1}, Visited, 0) + maps:get({X+1, Y-1}, Visited, 0).