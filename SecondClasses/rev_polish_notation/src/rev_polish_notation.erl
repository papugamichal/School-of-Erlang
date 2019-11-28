-module(rev_polish_notation).

-export([evaluate/1]).

evaluate(List)->
    R = lists:foldl(fun next/2, [],List),
    lists:last(R).

next(Elem, Stack) when is_integer(Elem) ->
    [Elem | Stack];
next(Elem, Stack) when is_function(Elem) andalso length(Stack) >= 2 ->
    {Last, Remaining} = get_last_and_ramaining(Stack),
    {Last1, Remaining1} = get_last_and_ramaining(Remaining),
    [Elem(Last, Last1) | Remaining1];
next(Elem, Stack) when is_function(Elem) ->    
    {false, "Error!"}.

get_last_and_ramaining(List = [H|T]) ->
    {H, T}.