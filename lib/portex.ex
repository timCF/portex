defmodule Portex do
  use Application
  require Exutils
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Portex.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Portex.Supervisor]
    Supervisor.start_link(children, opts)
  end

	#
	#	public
	#

	def open(name, command) when (is_atom(name) and is_binary(command)) do 
		true = :erlang.register(name, :erlang.open_port({:spawn, command}, [:binary]))
		:ok
	end
	def exec(input, port, condition \\ fn(_) -> true end, ttl \\ 1000) when (is_binary(input) and is_atom(port) and is_function(condition, 1) and is_integer(ttl)) do 
		exec_proc(input, port, condition, ttl) |> Exutils.safe
	end

	#
	#	priv
	#

	defp exec_proc(input, port, condition, ttl) do
		:erlang.port_command(port, input)
		receive_ans(condition, ttl, [])
	end
	defp receive_ans(condition, ttl, res) do
		receive do
			{_ , {:data, bin}} when is_binary(bin) ->
				case condition.(bin) do
					true -> [bin|res]
					false -> receive_ans(condition, ttl, res)
				end
			some -> 
				Logger.error "#{__MODULE__} : unexpected data #{inspect(some)}"
				receive_ans(condition, ttl, res)
		after
			ttl ->	
				res
		end
	end

end
