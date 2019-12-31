-module(ping).

-include_lib("eunit/include/eunit.hrl").

% API
-export([ping_all/5]).

% types
-type byte_integer() :: 0..255.
-type maybe_range() :: {byte_integer(), byte_integer()} | byte_integer().


-spec ping_all(FirstR, SecondR, ThirdR, FourthR, Count) -> ok when 
    FirstR :: maybe_range(),
    SecondR :: maybe_range(),
    ThirdR :: maybe_range(),
    FourthR :: maybe_range(),
    Count :: pos_integer().
ping_all(MaybeRange1, MaybeRange2, MaybeRange3, MaybeRange4, Count) ->
    IPCollection = make_ip_collection(MaybeRange1, MaybeRange2, MaybeRange3, MaybeRange4),
    ICMP = parse_icmp(Count),
    CoordinatorPID = spawn( fun() -> coordinator() end),
    lists:foreach(
        fun(IPAddress) -> spawn(fun() -> worker(CoordinatorPID, IPAddress, ICMP) end) end,
    IPCollection).

coordinator() ->
    io:fwrite("Coordinator: my PID is ~p\n", [self()]),
    coordinator(20000).

coordinator(Timeout) ->
    receive
        {WorkerPid, Msg} ->
            io:fwrite("Coordinator: Received message from worker: ~p \n~p\n", [WorkerPid, Msg]),
            coordinator(20000)
    after
        Timeout ->
            io:fwrite("Coordinator: Didn't received any message since last ~p miliseconds! Goodbye! \n", [Timeout])
    end.

worker(CoordinatorPid, IPAddress, ICMP) ->
    MyPid = self(),
    Result = ping(IPAddress, ICMP),
    CoordinatorPid ! {MyPid, Result},
    ok.

make_ip_collection(MaybeRange1, MaybeRange2, MaybeRange3, MaybeRange4) ->
    A = make_range(MaybeRange1),
    B = make_range(MaybeRange2),
    C = make_range(MaybeRange3),
    D = make_range(MaybeRange4),
    [lists:concat([A1, ".", B1, ".", C1, ".", D1]) || A1 <- A, B1 <- B, C1 <- C, D1 <- D].

make_range({A, B}) ->
    lists:seq(A, B);
make_range(Number) when is_number(Number) ->
    [Number].

parse_icmp(ICMP) ->
    integer_to_list(ICMP).

ping(StringIpAddress, Count) ->
    Cmd = "ping -c " ++ Count ++ " " ++ StringIpAddress,
    os:cmd(Cmd).

parse_result_form_ping_cmd(_) ->
    % Maybe use list matching and recursion matching first few element??
    % checkout https://erlang.org/doc/man/string.html
    ok.

%% ===================================================================================
%% Unit tests
%% ===================================================================================

%% making ranges test
integer_is_replaced_with_single_element_list_test() ->
    ?assertEqual([5], make_range(5)),
    ?assertEqual([-1], make_range(-1)),
    ?assertEqual([1], make_range(1)).

integer_is_replaced_with_single_element_list_with_random_int_test() ->
    [
        begin 
            RandomInt = rand:uniform(2000 * 1000) - 1000 * 1000,
            ?assertEqual([RandomInt], make_range(RandomInt))
        end || _ <- lists:seq(1, 1000 * 10) ].

range_is_replaced_with_a_list_starting_with_from_and_ending_with_to_test() ->
    Range = make_range({5, 255}),
    [H|_] = Range,
    ?assertEqual(5, H),
    ?assertEqual(255, lists:last(Range)).

one_element_range_works_test() ->
    Range = make_range({2, 2}),
    ?assertEqual([2], Range).

make_ip_collection_test() ->
    IPCollection = make_ip_collection(192, 168, 1, 1),
    [H|_] = IPCollection,
    ?assertEqual("192.168.1.1", H).

fail_ping_result() ->
    "PING 192.168.0.2 (192.168.0.2): 56 data bytes\n"
    "Request timeout for icmp_seq 0\n"
    "Request timeout for icmp_seq 1\n"
    "Request timeout for icmp_seq 2\n"
    "\n"
    "--- 192.168.0.2 ping statistics ---\n"
    "4 packets transmitted, 0 packets received, 100.0% packet loss\n".

successful_ping_result() ->
    "PING 192.168.43.179 (192.168.43.179): 56 data bytes\n"
    "\n"
    "64 bytes from 192.168.43.179: icmp_seq=0 ttl=64 time=0.439 ms\n"
    "64 bytes from 192.168.43.179: icmp_seq=1 ttl=64 time=0.093 ms\n"
    "64 bytes from 192.168.43.179: icmp_seq=2 ttl=64 time=0.091 ms\n"
    "64 bytes from 192.168.43.179: icmp_seq=3 ttl=64 time=0.088 ms\n"
    "\n"
    "--- 192.168.43.179 ping statistics ---\n"
    "4 packets transmitted, 4 packets received, 0.0% packet loss\n"
    "round-trip min/avg/max/stddev = 0.088/0.178/0.439/0.151 ms\n".

parisng_failed_ping_result_test() ->
    ParseResult = parse_result_form_ping_cmd(fail_ping_result()),
    ?assertEqual(0, ParseResult).

parisng_succesfull_ping_result_test() ->
    ParseResult = parse_result_form_ping_cmd(successful_ping_result()),
    ?assertEqual(0, ParseResult).