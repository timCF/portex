defmodule Portex.Worker do
	use ExActor.GenServer
	require Logger
	
	definit([name, command]) do
		true = :erlang.register(name, self())
		{:ok, :erlang.open_port({:spawn, command}, [:binary])}
	end
	defcall exec(input, condition, ttl), state: port do
		:erlang.port_command(port, input)
		{:reply, receive_ans(condition, ttl, []), port}
	end
	definfo some, state: port do
		Logger.error "#{__MODULE__} : unexpected data in definfo #{inspect(some)}"
		{:noreply, port}
	end
	#
	#	priv
	#
	defp receive_ans(condition, ttl, res) do
		receive do
			{_ , {:data, bin}} when is_binary(bin) ->
				case condition.(bin) do
					true -> receive_ans(condition, ttl, [bin|res])
					false -> receive_ans(condition, ttl, res)
				end
			some -> 
				Logger.error "#{__MODULE__} : unexpected data #{inspect(some)}"
				receive_ans(condition, ttl, res)
		after
			ttl -> res
		end
	end
end