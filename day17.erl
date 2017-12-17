-module(day17).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> solve(0, [0], 356, 1).
solve_part2() -> solve2(0, 1, 356, 1, 0).

solve(LastPos, Values, Steps, NextValue) -> 
    NextPos = (LastPos + Steps) rem length(Values),
    {A, B} = lists:split(NextPos+1, Values),
    case NextValue of
        2017 -> hd(B);
        _ ->  solve((NextPos+1) rem (length(Values)+1), A ++ [NextValue] ++ B, Steps, NextValue+1)
    end.

solve2(_, _, _, 50000000, AfterZero) -> AfterZero; 
solve2(LastPos, ValueCount, Steps, NextValue, AfterZero) -> 
    NextPos = (LastPos + Steps) rem ValueCount,
    case NextPos of
        0 -> solve2((NextPos+1) rem (ValueCount + 1), ValueCount+1, Steps, NextValue+1, NextValue);
        _ -> solve2((NextPos+1) rem (ValueCount + 1), ValueCount+1, Steps, NextValue+1, AfterZero)
    end.
