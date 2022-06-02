-module(erlgosduma).

-compile(export_all).

-type error_result() :: {error, binary()}.
-type result() :: {ok, any(), any()} | error_result().

-spec request(string()) -> result().
request(Method)->
	request(Method, []).

-spec request(string(), list()) -> result().
request(Method, Query)->
	Token = application:get_env("gd_token"),

	case Token of
		undefined -> error("Token is undefined")
	end,

	URL = "http://api.duma.gov.ru/api/" ++ Token ++ "/" ++ Method ++ ".json?" ++ uri_string:compose_query(Query),

	case hackney:get(URL) of
		{ok, 200, _, Ref} ->
			{ok, Body} = hackney:body(Ref),
			jsone:decode(Body);
		{error, Reason} ->
			{error, Reason}
	end.

-spec topics() -> result().
topics()->
	request("topics").

-spec classes() -> result().
classes()->
	request("classes").

-spec deputies() -> result().
deputies()->
	request("deputies").

-spec committees() -> result().
committees()->
	request("committees").

-spec regional_organs() -> result().
regional_organs()->
	request("regional-organs").

-spec federal_organs() -> result().
federal_organs()->
	request("federal-organs").

-spec stages() -> result().
stages()->
	request("stages").

-spec instances() -> result().
instances()->
	request("instances").

-spec periods() -> result().
periods()->
	request("periods").

-spec search() -> result().
search()->
	request("search").

-spec search(list()) -> result().
search(Query)->
	request("search", Query).

-spec transcript(integer()) -> result().
transcript(Number)->
	request("transcript/" ++ Number).

-spec transcript_resolution(integer()) -> result().
transcript_resolution(Number)->
	request("transcriptResolution/" ++ Number).

-spec transcript_full(string()) -> result().
transcript_full(Date)->
	request("transcriptFull/" ++ Date).

-spec questions() -> result().
questions()->
	request("questions").

-spec transcript_question(integer(), integer()) -> result().
transcript_question(Meeting, Question)->
	request("transcriptQuestion/" ++ Meeting ++ "/" ++ Question).

-spec session() -> result().
session()->
	request("session").

-spec law_program(integer()) -> result().
law_program(Session)->
	request("lawProgram/" ++ Session).

-spec transcript_deputy(list()) -> result().
transcript_deputy(Query)->
	request("transcriptDeputy", Query).

-spec deputy(integer()) -> result().
deputy(Id)->
	request("deputy", [{"id", Id}]).

-spec requests() -> result().
requests()->
	request("requests").

-spec vote_search(list()) -> result().
vote_search(Query)->
	request("voteSearch", Query).

-spec vote(integer()) -> result().
vote(Id)->
	request("vote/" ++ Id).

-spec vote_stats(list()) -> result().
vote_stats(Query)->
	request("voteStats", Query).