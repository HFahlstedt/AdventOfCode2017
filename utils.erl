-module(utils).
-export([read_textfile/1]).

read_textfile(Filename) -> 
    {ok, Bin} = file:read_file(Filename),
    unicode:characters_to_list(Bin).
