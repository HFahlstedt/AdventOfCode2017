-module(day14).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> lists:sum(lists:map(fun(H) -> sum_hash(H) end, input_strings())). 

solve_part2() -> count_regions(maps:from_list(lists:map(fun(X) -> {X, 1} end, find_used_squares(lists:map(fun(X) -> binary_hash(X) end, input_strings()), 0, 0, []))), 0).

input_strings() -> lists:map(fun(X) -> "hxtvlmkl-" ++ integer_to_list(X) end, lists:seq(0, 127)).

sum_hash(I) -> lists:sum(binary_hash(I)).

binary_hash(I) -> lists:map(fun(Y) -> Y-48 end, lists:flatten(lists:map(fun(X) -> string:right("00000000" ++ integer_to_list(X, 2), 8) end, day10:knot_hash(I)))).

find_used_squares([], _Col, _Row, Used) -> Used; 
find_used_squares([[]|Rows], _Col, Row, Used) -> find_used_squares(Rows, 0, Row+1, Used);
find_used_squares([[1|Rest]|Rows], Col, Row, Used) -> find_used_squares([Rest|Rows], Col+1, Row, Used ++ [{Col, Row}]);
find_used_squares([[0|Rest]|Rows], Col, Row, Used) -> find_used_squares([Rest|Rows], Col+1, Row, Used).


count_regions(Used, Count) ->
    Size = maps:size(Used),
    io:fwrite("~w~n", [Size]),
    case Size > 0 of 
        true ->
            R = find_region(hd(maps:keys(Used)), Used),
            count_regions(maps:without(R, Used), Count+1);
        _Else -> Count
    end.

find_region([], _) -> [];
find_region({C, R}, Used) -> 
    case maps:get({C, R}, Used, not_found) of
        not_found -> [];
        _ ->
            %io:fwrite("~w~n", [{C, R}]),
            Existing = [{C, R}],
            sets:to_list(sets:from_list(Existing ++ 
            find_region({C-1, R}, maps:without(Existing ++ [{C+1, R}, {C, R-1}, {C, R+1}], Used)) ++ 
            find_region({C+1, R}, maps:without(Existing ++ [{C-1, R}, {C, R-1}, {C, R+1}], Used)) ++ 
            find_region({C, R-1}, maps:without(Existing ++ [{C+1, R}, {C-1, R}, {C, R+1}], Used)) ++ 
            find_region({C, R+1}, maps:without(Existing ++ [{C+1, R}, {C, R-1}, {C-1, R}], Used))))
    end.