-module(average).

-export([average/1]).

average(_List) ->
    case _List of 
        [] ->
            0;
        _ ->
            sum(_List) / list_lenght(_List)
    end.

sum(List) ->
    %sum_buildin(List).
    sum_recursion(List).

list_lenght(List) ->
    %list_lenght_buildin(List).
    list_lenght_recursion(List).

sum_buildin(List) ->
    lists:sum(List).

sum_recursion([H|T]) ->
    case H of
        [] ->
            0;
        _ ->    
            case T of
                [] -> 
                    H;
                _ ->
                    H + sum_recursion(T)
                end
        end.

list_lenght_buildin(List) ->
    length(List).

list_lenght_recursion([H|T]) -> 
    case H of
        [] ->
            0;
        _ ->    
            case T of
                [] -> 
                    1;
                _ ->
                1 + list_lenght_recursion(T)
            end
        end.
