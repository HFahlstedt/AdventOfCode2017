-module(utils).
-export([read_textfile/1, read_lines/1, rotate_list_r/2, rotate_list_l/2]).

rotate_list_r(L, N) when N =< length(L) ->  lists:nthtail(length(L) - N, L) ++ lists:sublist(L, 1, length(L) - N);
rotate_list_r(L, N) ->  lists:nthtail(length(L) - (N rem length(L)), L) ++ lists:sublist(L, 1, length(L) - (N rem length(L))).

rotate_list_l(L, N) -> lists:sublist(L, N+1, length(L)) ++ lists:sublist(L, N).

read_textfile(Filename) -> 
    {ok, Bin} = file:read_file(Filename),
    unicode:characters_to_list(Bin).

read_lines(Filename) -> string:tokens(read_textfile(Filename), "\r\n").