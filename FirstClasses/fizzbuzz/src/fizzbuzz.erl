-module(fizzbuzz).

-export([fizzbuzz/0]).

fizzbuzz() ->
    lists:map(fun fb/1, generate_input_list(100)).

fb(Number) when Number rem 15 == 0 -> fizzbuzz;
fb(Number) when Number rem 5 == 0 -> buzz;
fb(Number) when Number rem 3 == 0 -> fizz;
fb(Number) -> Number.

generate_input_list(Number) ->
    lists:seq(1, Number).
    