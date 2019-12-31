-module(top_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([make_mach_specs/1]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
        ChildSpecs = [
            % make_mach_specs(a_sup), make_mach_specs(b_sup), make_mach_specs(c_sup), %% 4.1.1
            make_mach_specs(a_sup), %% 4.1.2 && 4.1.3 
            make_mach_specs(c_sup)  %% 4.1.3 
       ],
    {ok, {SupFlags, ChildSpecs}}.

make_mach_specs(Name) ->
    #{id => Name, start => {Name, start_link, []}}.