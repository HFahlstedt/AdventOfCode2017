-module(day18).
-export([solve_part1/0, solve_part2/0, start_program/2]).

solve_part1() -> execute(maps:new(), input(), 1, 0).

solve_part2() -> 
    P1 = spawn(day18, start_program, [p0, 0]),
    P2 = spawn(day18, start_program, [p1, 1]),
    P1 ! {go, P2},
    P2 ! {go, P1}.

execute(Regs, Instructions, Ip, LastFreq) -> 
    case lists:nth(Ip, Instructions) of 
        {set, Reg, Val} -> execute(maps:put(Reg, val(Val, Regs), Regs), Instructions, Ip+1, LastFreq);
        {mul, Reg, Val} -> execute(maps:put(Reg, val(Reg, Regs) * val(Val, Regs), Regs), Instructions, Ip+1, LastFreq);
        {add, Reg, Val} -> execute(maps:put(Reg, val(Reg, Regs) + val(Val, Regs), Regs), Instructions, Ip+1, LastFreq);
        {mod, Reg, Val} -> execute(maps:put(Reg, val(Reg, Regs) rem val(Val, Regs), Regs), Instructions, Ip+1, LastFreq);
        {jgz, Reg, Val} -> 
            case val(Reg, Regs) of
                X when X > 0 -> execute(Regs, Instructions, Ip+Val, LastFreq);
                _ ->  execute(Regs, Instructions, Ip+1, LastFreq)
            end;
        {snd, Freq} -> execute(Regs, Instructions, Ip+1, val(Freq, Regs));
        {rcv, Reg} -> 
            case val(Reg, Regs) > 0 of
                true -> LastFreq;
                _ -> execute(Regs, Instructions, Ip+1, LastFreq)
            end
    end.

start_program(Me, P) -> 
    receive 
        {go, Other} -> execute2(maps:from_list([{p, P}]), input(), 1, Me, Other, 0)
    end.

execute2(_Regs, Instructions, Ip, Me, _OtherP, SendCount) when (Ip < 1) or (Ip > length(Instructions)) -> io:fwrite("~w~n", [{finished, Me, SendCount}]);
execute2(Regs, Instructions, Ip, Me, OtherP, SendCount) -> 
    case lists:nth(Ip, Instructions) of 
        {set, Reg, Val} -> execute2(maps:put(Reg, val(Val, Regs), Regs), Instructions, Ip+1, Me, OtherP, SendCount);
        {mul, Reg, Val} -> execute2(maps:put(Reg, val(Reg, Regs) * val(Val, Regs), Regs), Instructions, Ip+1, Me, OtherP, SendCount);
        {add, Reg, Val} -> execute2(maps:put(Reg, val(Reg, Regs) + val(Val, Regs), Regs), Instructions, Ip+1, Me, OtherP, SendCount);
        {mod, Reg, Val} -> execute2(maps:put(Reg, val(Reg, Regs) rem val(Val, Regs), Regs), Instructions, Ip+1, Me, OtherP, SendCount);
        {jgz, Reg, Val} -> 
            case val(Reg, Regs) of
                X when X > 0 -> execute2(Regs, Instructions, Ip + val(Val, Regs), Me, OtherP, SendCount);
                _ ->  execute2(Regs, Instructions, Ip+1, Me, OtherP, SendCount)
            end;
        {snd, Freq} -> OtherP ! val(Freq, Regs), execute2(Regs, Instructions, Ip+1, Me, OtherP, SendCount+1);
        {rcv, Reg} -> 
            receive
                Val -> execute2(maps:put(Reg, Val, Regs), Instructions, Ip+1, Me, OtherP, SendCount)
            after
                1000 -> io:fwrite("~w~n", [{deadlock, Me, SendCount}])
            end
    end.

val(Key, Regs) when is_atom(Key) -> maps:get(Key, Regs, 0);
val(Key, _Regs) -> Key.

input() -> lists:map(fun (X) -> parse_instruction(X) end, utils:read_lines("day18.txt")).

parse_instruction(I) ->
    case re:run(I, "(set|mul|add|mod|jgz|snd|rcv) (([a-z])|(-?[0-9]+))( (([a-z])|(-?[0-9]+)))?", [{capture, [1, 3, 4, 7, 8], list}]) of
        {match, [C, R, [], [], []]} -> {list_to_atom(C), list_to_atom(R)};
        {match, [C, R, [], [], V]} -> {list_to_atom(C), list_to_atom(R), list_to_integer(V)};
        {match, [C, [], V1, [], V2]} -> {list_to_atom(C), list_to_integer(V1), list_to_integer(V2)};
        {match, [C, R1, [], R2, []]} -> {list_to_atom(C), list_to_atom(R1), list_to_atom(R2)};
        {match, [C, [], V, R, []]} -> {list_to_atom(C), list_to_integer(V), list_to_atom(R)}
    end.
