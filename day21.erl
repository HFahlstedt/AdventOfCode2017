-module(day21).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> length(lists:filter(fun(X) -> X == $# end, lists:flatten(repeate_enhance(initial(), input(), 5)))).
solve_part2() -> length(lists:filter(fun(X) -> X == $# end, lists:flatten(repeate_enhance(initial(), input(), 18)))).

repeate_enhance(Image, _, 0) -> Image;
repeate_enhance(Image, Map, N) -> repeate_enhance(enhance_image(Image, Map), Map, N-1).

enhance_rows(Image, Map, Off, RowOff, ChunkSize, Rows) when (Off+ChunkSize) =< length(hd(Image)) ->
    enhance_rows(Image, Map, Off+ChunkSize, RowOff, ChunkSize, lists:zipwith(fun(A, B) -> A ++ B end, Rows, find_next(get_chunk(Image, Off, RowOff, ChunkSize), Map)));
enhance_rows(_, _, _, _, _, Rows) -> Rows.

get_chunk(Image, Offset, RowOffset, ChunkSize) -> get_chunk(Image, Offset, RowOffset, ChunkSize, ChunkSize).

get_chunk(_, _, _, _, 0) -> [];
get_chunk(Image, Off, RowOff, ChunkSize, Count) -> get_chunk(Image, Off, RowOff, ChunkSize, Count-1) ++ [lists:sublist(lists:nth(RowOff+Count, Image), Off+1, ChunkSize)].

initial() -> [
    ".#.", 
    "..#", 
    "###"
].

enhance_image(Rows, Map) when length(Rows) rem 2 == 0 -> enhance(Rows, Map, 0, 2);
enhance_image(Rows, Map) -> enhance(Rows, Map, 0, 3).

enhance(Image, Map, RowOff, Count) when length(Image) >= RowOff + Count -> enhance_rows(Image, Map, 0, RowOff, Count, empty_rows(Count+1)) ++ enhance(Image, Map, RowOff+Count, Count);
enhance(_, _, _, _) -> [].  

empty_rows(N) -> lists:map(fun(_) -> [] end, lists:seq(1, N)).

find_next(K, Map) -> 
    case maps:get(K, Map, no) of 
        Val when Val /= no -> Val;
        no -> 
            case maps:get(rotate(K), Map, no) of
                Val when Val /= no -> Val;
                no -> 
                    case maps:get(rotate(rotate(K)), Map, no) of
                        Val when Val /= no -> Val;
                        no ->
                            case maps:get(rotate(rotate(rotate(K))), Map, no) of
                                Val when Val /= no -> Val;
                                no ->
                                    case maps:get(flip_h(K), Map, no) of
                                        Val when Val /= no -> Val;
                                        no ->
                                            case maps:get(flip_v(K), Map, no) of
                                                Val when Val /= no -> Val;
                                                no ->
                                                    case maps:get(flip_h(rotate(K)), Map, no) of
                                                        Val when Val /= no -> Val;
                                                        no ->
                                                            case maps:get(flip_v(rotate(K)), Map, no) of
                                                                Val when Val /= no -> Val;
                                                                no -> fail
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.


flip_h([[A, B], [C, D]]) -> [[C, D], [A, B]];
flip_h([[A, B, C], X, [G, H, I]]) -> [[G, H, I], X, [A, B, C]].

flip_v([[A, B], [C, D]]) -> [[B, A], [D, C]];
flip_v([[A, B, C], [D, E, F], [G, H, I]]) -> [[C, B, A], [F, E, D], [I, H, G]].

rotate([[A, B], [C, D]]) -> [[C, A], [D, B]];
rotate([[A, B, C], 
        [D, E, F], 
        [G, H, I]]) -> 
       [[G, D, A], 
        [H, E, B], 
        [I, F, C]].


input() -> 
    maps:from_list(lists:map(
        fun(X) -> 
            [A, B] = string:tokens(X, " => "), 
            list_to_tuple([string:tokens(A, "/"), string:tokens(B, "/")]) end, 
        utils:read_lines("day21.txt"))).
