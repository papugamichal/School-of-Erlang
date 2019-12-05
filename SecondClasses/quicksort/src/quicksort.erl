-module(quicksort).

-export([sort/1]).
-export([while/1]).

sort([]) -> [];
sort(L = [H|_]) ->
    %sort_step_by_step(L).
    sort_with_list_comprachentions(L).
    %sort_with_foldl(L).

% 1.1 sort_step_by_step
sort_step_by_step([H|T]) ->
    S = lists:filter(fun(X) -> X < H end, T), 
    B = lists:filter(fun(X) -> X >= H end, T),
    sort_step_by_step(S) ++ [H] ++ sort_step_by_step(B).

% 1.2 sort_with_list_comprachentions
sort_with_list_comprachentions([H|T]) ->
    S = lists:sort([X || X <- T, X < H]),
    B = lists:sort([X || X <- T, X >= H]),
    S ++ [H] ++ B.

%u sing foldl
sort_with_foldl(L = [H|_]) ->
    {Smaller, Bigger} = lists:foldl(
        fun(Element, {Smaller, Bigger}) ->
            case Element of 
                E when E < H ->
                    {[E|Smaller], Bigger};
                E when E >= H ->
                    {Smaller, [E|Bigger]}
            end
        end,
    {[], []}, L), 
    lists:sort(Smaller) ++  lists:sort(Bigger). 

