-module(user_exists).
-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([add_user/1, remove_user/1, user_exists/1]).

start_link() ->
   gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
    State = [],
   {ok, State}.

handle_cast(_Msg, State) ->
   {noreply, State}.

handle_info(_Info, State) ->
   {noreply, State}.

terminate(_Reason, _State) ->
   ok.

code_change(_OldVsn, State, _Extra) ->
   {ok, State}.

%% Implementation
add_user(Login) ->
   gen_server:call(?MODULE, {add_user, Login}).

remove_user(Login) ->
   gen_server:call(?MODULE, {remove_user, Login}).

user_exists(Login) ->
   gen_server:call(?MODULE, {user_exists, Login}).
              
handle_call({add_user, Login}, _From, State) ->
   case lists:member(Login, State) of
      false ->
         NewState = [Login|State],
         {reply, {added, Login}, NewState};
      true ->
         {reply, {error, "User already exists!"}, State}
   end;

handle_call({remove_user, Login}, _From, State) ->
   case lists:member(Login, State) of
      true ->
         NewState = lists:delete(Login, State),
         {reply, {removed, Login}, NewState};
      _ ->
         {reply, {error, "User not exists!"}, State}
   end;
   
handle_call({user_exists, Login}, _From, State) ->
   {reply, lists:member(Login, State), State}.
