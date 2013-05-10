-module(f).
-export([read/0, read/1, write/1, write/2, append/1, append/2, read_num/0, read_num/1]).

write(Line) -> write(Line, "test.txt").
write(Line, File) ->
	{ok, IODevice} = file:open(File, [write]),
	file:write(IODevice, Line),
	file:close(IODevice).

append(Line) -> append(Line, "test.txt").
append(Line, File) ->
	{ok, IODevice} = file:open(File, [append]),
	file:write(IODevice, Line),
	file:close(IODevice).

read() -> read("test.txt").
read(File) ->
   	{ok, Device} = file:open(File, [read]),
   	try get_all_lines(Device)
   		after file:close(Device)
    	end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

parse_num(S) -> [element(1, string:to_integer(Y)) || Y <- lists:append([string:tokens(X, " ") || X <- string:tokens(S, "\n")])].

read_num() -> parse_num(read()).
read_num(File) -> parse_num(read(File)).

