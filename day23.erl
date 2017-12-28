-module(day23).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> execute(maps:new(), input(), 1, 0).
solve_part2() -> length(lists:filter(fun(X) -> not is_prime(X) end, lists:seq(105700, 122700, 17))).

execute(_, Instructions, Ip, Count) when (Ip < 1) or (Ip > length(Instructions)) -> Count;
execute(Regs, Instructions, Ip, Count) -> 
    case lists:nth(Ip, Instructions) of 
        {set, Reg, Val} -> execute(maps:put(Reg, val(Val, Regs), Regs), Instructions, Ip+1, Count);
        {sub, Reg, Val} -> execute(maps:put(Reg, maps:get(Reg, Regs, 0) - val(Val, Regs), Regs), Instructions, Ip+1, Count);
        {mul, Reg, Val} -> execute(maps:put(Reg, maps:get(Reg, Regs, 0) * val(Val, Regs), Regs), Instructions, Ip+1, Count+1);
        {jnz, Reg, Val} -> 
            case val(Reg, Regs) of
                X when X /= 0 -> execute(Regs, Instructions, Ip+Val, Count);
                _ ->  execute(Regs, Instructions, Ip+1, Count)
            end
    end.

val(Key, Regs) when is_atom(Key) -> maps:get(Key, Regs, 0);
val(Key, _Regs) -> Key.

is_prime(X) when X rem 2 == 0 -> false;
is_prime(X) -> is_prime(X, 3).

is_prime(X, D) when D*D > X -> true;
is_prime(X, D) when X rem D == 0 -> false;
is_prime(X, D) -> is_prime(X, D+2).

input() -> lists:map(fun (X) -> parse_instruction(X) end, utils:read_lines("day23.txt")).

parse_instruction(I) ->
    case re:run(I, "(set|mul|jnz|sub) (([a-z])|(-?\\d+)) (([a-z])|(-?\\d+))", [{capture, [1, 3, 4, 6, 7], list}]) of
        {match, [C, R, [], [], V]} -> {list_to_atom(C), list_to_atom(R), list_to_integer(V)};
        {match, [C, [], V1, [], V2]} -> {list_to_atom(C), list_to_integer(V1), list_to_integer(V2)};
        {match, [C, R1, [], R2, []]} -> {list_to_atom(C), list_to_atom(R1), list_to_atom(R2)}
    end.
