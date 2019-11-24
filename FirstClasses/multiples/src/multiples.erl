-module(multiples).

-export([thousand_sum/0]).
-export([generate_input_collection/1]).
-export([filter_collection/1]).

thousand_sum() -> 
    FilterCollection = filter_collection(generate_input_collection(1000)),
    lists:sum(FilterCollection).

generate_input_collection(Lenght) ->
    case Lenght of
        0  ->
           [];
        L when L - 1 == 0 ->
            1;
        _ ->
            lists:seq(1, Lenght - 1)
    end.

filter_collection(List) ->
    case List of
        [] ->
            [];
        _ ->
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
            List)
        end.