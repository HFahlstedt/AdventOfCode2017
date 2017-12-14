-module(day5).
-export([solve_part1/0, solve_part2/0]).

% Same solution for both parts, the only difference is how the instructions are modified. 
% Read instruction, calculate jump, check if jump is outside of memory, if not jump and start over.

solve_part1() -> solve(1, mapped_input(), 0, part1).
solve_part2() -> solve(1, mapped_input(), 0, part2).

solve(IP, Instructions, Steps, Part) -> 
    case IP > maps:size(Instructions) of
        true -> Steps;
        _Else -> Jump = maps:get(IP, Instructions), solve(IP + Jump, modify_instruction(Part, IP, Jump, Instructions), Steps+1, Part)
    end.

modify_instruction(part2, IP, Jump, Instructions) when Jump > 2 -> maps:put(IP, Jump - 1, Instructions);
modify_instruction(_, IP, Jump, Instructions) -> maps:put(IP, Jump + 1, Instructions).

mapped_input() -> maps:from_list(lists:zip(lists:seq(1, length(input())), input())).

input() -> lists:map(fun(X) -> list_to_integer(X) end, string:tokens(utils:read_textfile("day5.txt"), "\r\n")).
