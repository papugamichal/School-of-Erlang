-module(multiples).

-export([thousand_sum/0]).  
-export([filter_collection/1]).

thousand_sum() -> 
    FilterCollection = filter_collection(generate_input_collection(1000)),
    lists:sum(FilterCollection).

generate_input_collection(Lenght) ->
    case Lenght of
        0  ->
           [];
        1  ->
            lists:seq(1, 1);
        _ ->
            lists:seq(1, Lenght - 1)
    end.

filter_collection(List) ->
    lists:filter(
    fun(Element) ->
        case Element of
            E when E rem 3 == 0 ->
                true;
            E when E rem 5 == 0 ->
                true;
            _ ->
                false
            end
        end,
    List).
        