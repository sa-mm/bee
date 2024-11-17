defmodule Bee.Monitor do
  use GenServer

  alias Bee.Sup

  # Client
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def monitor_worker(pid) do
    GenServer.cast(__MODULE__, {:monitor, pid})
  end

  # Server
  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:monitor, pid}, _state) do
    Process.monitor(pid)
    {:noreply, :monitoring}
  end

  @impl true
  def handle_info({:DOWN, ref, _, _pid, _reason}, _) do
    Process.demonitor(ref)
    Sup.start_child({Bee.Worker, []})
    {:noreply, :demonitored}
  end
end
