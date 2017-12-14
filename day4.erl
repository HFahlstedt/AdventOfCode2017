-module(day4).
-export([solve_part1/0, solve_part2/0]).

% Part one: Add the words to a set and compare the size of the set with the count of words in the passohrase,
% if there are any duplicates the size of the set will be less than the count of words => invalid
solve_part1() -> length(lists:filter(fun(L) -> length(L) == sets:size(sets:from_list(L)) end, input())).

% Part two: Similar solution as in Part One, but before adding words to the set, sort them. In this way all words 
% that are permutations of each other will be equal. Then, again, compare the size of the set with the count of 
% words in the passphrase.  
solve_part2() -> length(
    lists:filter(fun(L) -> length(L) == sets:size(sets:from_list(lists:map(fun(X) -> sort_atom(X) end, L))) end, input())).

sort_atom(A) -> list_to_atom(lists:sort(atom_to_list(A))).

input() -> lists:map(fun(X) -> lists:map(fun(Y) -> list_to_atom(Y) end, string:tokens(X, " ")) end, string:tokens(utils:read_textfile("day4.txt"), "\r\n")).
