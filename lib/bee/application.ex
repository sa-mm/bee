defmodule Bee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    case Node.self() do
      :node1@comps2018 -> Node.connect(:node2@comps2018)
      :node2@comps2018 -> Node.connect(:node1@comps2018)
      node -> dbg(node)
    end

    children = [
      {Task.Supervisor, name: Bee.TaskSupervisor},
      # Starts a worker by calling: Bee.Worker.start_link(arg)
      {Bee.Sup, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bee.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
