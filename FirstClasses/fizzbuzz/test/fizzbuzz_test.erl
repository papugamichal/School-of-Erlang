-module(fizzbuzz_test).

-include_lib("eunit/include/eunit.hrl").

fb(N) when N rem 15 == 0 -> fizzbuzz;
fb(N) when N rem 3 == 0 -> fizz;
fb(N) when N rem 5 == 0 -> buzz;
fb(N) -> N.

fizzbuzz_small_test() ->
    Expected = [fb(N) || N <- lists:seq(1, 6)],
    io:fwrite("~p", [Expected]),
    % mp - shouldn't fizzbuzz() know how large should output collection be?
    % mp - this tests will never pass since fizzbuzz() genereate fix lenght output, right?
    ?assertEqual(Expected, fizzbuzz:fizzbuzz()).

fizzbuzz_big_test() ->
    Expected = [fb(N) || N <- lists:seq(1, 100)],
    ?assertEqual(Expected, fizzbuzz:fizzbuzz()).