-module(fibonacci_sum).

-export([fibonacci_sum/0, fibonacci_sum/4]).

fibonacci_sum() ->
    Limit = 4 * 1000 * 1000,
    fibonacci_sum(1, 1, 0, Limit).

fibonacci_sum(_Prev, _Curr, _Sum, _Limit) ->
    case _Sum of
        _Sum when _Curr =< _Limit andalso _Curr rem 2 == 0 ->
            _Curr + fibonacci_sum(_Curr, _Prev + _Curr, _Sum + 1, _Limit);
        _Sum when _Curr =< _Limit ->
            fibonacci_sum(_Curr, _Prev + _Curr, _Sum + 1, _Limit);
        _ ->
            0
        end.
