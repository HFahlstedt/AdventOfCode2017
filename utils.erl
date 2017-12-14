-module(utils).
-export([read_textfile/1, read_lines/1]).

read_textfile(Filename) -> 
    {ok, Bin} = file:read_file(Filename),
    unicode:characters_to_list(Bin).

read_lines(Filename) -> string:tokens(read_textfile(Filename), "\r\n").