defmodule Bee.Sup do
  use DynamicSupervisor

  # Client
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(child) do
    DynamicSupervisor.start_child(__MODULE__, child)
  end

  # Server
  @impl true
  def init(_init_arg) do
    [
      {Bee.Monitor, []},
      # Starts a worker by calling: Bee.Worker.start_link(arg)
      {Bee.Worker, []}
    ]
    |> Enum.map(fn child ->
      Task.Supervisor.start_child(
        Bee.TaskSupervisor,
        fn ->
          start_child(child)
        end,
        restart: :transient
      )
    end)

    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
