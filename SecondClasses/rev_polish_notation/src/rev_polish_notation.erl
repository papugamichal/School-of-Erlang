-module(rev_polish_notation).

-export([evaluate/1]).

evaluate(List)->
    R = lists:foldl(fun next/2, [], List),
    lists:last(R).

next(Elem, Stack) when is_integer(Elem) ->
    [Elem | Stack];
next(Elem, Stack) when is_function(Elem)->
    case get_fun_args_number(Elem) of
        Arity when Arity == 2 andalso length(Stack) >= 2 ->
            {Last, Remaining} = get_stack_head_and_ramaining(Stack),
            {Last1, Remaining1} = get_stack_head_and_ramaining(Remaining),
            [Elem(Last, Last1) | Remaining1];
        Arity when Arity == 1 andalso length(Stack) >= 1 ->
            {Last, Remaining} = get_stack_head_and_ramaining(Stack),
            [Elem(Last) | Remaining];
        Arity when Arity >= 1 andalso length(Stack) >= 0 ->
            {false, "Got function but there is not enough  arguments!"}
    end.

get_fun_args_number(Function) ->
    {_, Number} = erlang:fun_info(Function,arity),
    Number.

get_stack_head_and_ramaining([H|T]) ->
    {H, T}.