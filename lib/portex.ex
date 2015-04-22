defmodule Portex do
  use Application

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
		:ok = :supervisor.start_child(Portex.Supervisor, Supervisor.Spec.worker(Portex.Worker, [[name, command]], [id: name, restart: :permanent])) |> elem(0)
	end
	def exec(name, input, condition \\ fn(_) -> true end, ttl \\ 1000) when (is_binary(input) and is_atom(name) and is_function(condition, 1) and is_integer(ttl)) do
		Portex.Worker.exec(name, input, condition, ttl)
	end

end
