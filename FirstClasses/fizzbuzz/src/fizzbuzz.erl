-module(fizzbuzz).

-export([fizzbuzz/0]).

fizzbuzz() ->
    lists:map(
    fun(Number) ->
        case Number of
            N when N rem 15 == 0 ->
                fizzbuzz;
            N when N rem 5 == 0 ->
                buzz;
            N when N rem 3 == 0 ->
                fizz;
            _ ->
                Number
            end
        end,
    generate_input_list()).

generate_input_list() ->
    lists:seq(1, 100).
    