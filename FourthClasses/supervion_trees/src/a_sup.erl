-module(a_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    %ChildSpecs = [top_sup:make_mach_specs(b_sup)], %% 4.1.2
    ChildSpecs = [top_sup:make_mach_specs(b_sup)], %% 4.1.3
    {ok, {SupFlags, ChildSpecs}}.
