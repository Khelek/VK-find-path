-module(t).
-export([init/0, test/0, test_my_fr/0]).

init() ->
	inets:start(),
	ssl:start().

make_request(Method, Params) ->
	Base_uri = "https://api.vk.com/method/",
	Request_uri = Base_uri ++ Method ++ "?" ++ Params,
	Response = httpc:request(Request_uri),
	{ok, {_, _, Html_response}} = Response,
	Html_response.

get_friends_full_info(Id) ->
	Method = "friends.get",
	Params = "uid=" ++ integer_to_list(Id) ++ "&fields=domain",
	_Html_response = make_request(Method, Params).

get_friends_id(Id) ->
	Method = "friends.get",
	Params = "uid=" ++ integer_to_list(Id),
	_Html_response = make_request(Method, Params).

get_fr_by_id_list(Id_list) ->
	[{get_friends_id(Temp_id), "fr/" ++ integer_to_list(Temp_id) ++ ".txt"}||Temp_id <- Id_list].

test() ->
	L = [55827129, 5127441, 15399203, 35862539, 13327845, 49494646, 18148906],
	LL = get_fr_by_id_list(L),
	[f:write(Temp_resp, Temp_file) ||{Temp_resp, Temp_file} <- LL].

test_my_fr() ->
	{_,Time_begin} = erlang:localtime(),
	Id = 55827129,
	My_fr = get_friends_id(Id),
	{struct, Parsed_json} = mochijson2:decode(list_to_binary(My_fr)),
	Response = lists:nth(1, Parsed_json),
	{_, Fr_list} = Response,
	LL = get_fr_by_id_list(Fr_list),
	Res = [f:write(Temp_resp, Temp_file) ||{Temp_resp, Temp_file} <- LL],
	{_,Time_end} = erlang:localtime(),
	{Res, {'time begin', Time_begin}, {'time end', Time_end}}.


%https://api.vk.com/method/friends.get?uid=55827129&count=20&fields=domain