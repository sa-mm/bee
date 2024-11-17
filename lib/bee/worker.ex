defmodule Bee.Worker do
  use GenServer

  alias Bee.Monitor

  # client
  def start_link(init_args) do
    on_start =
      GenServer.start_link(__MODULE__, init_args, name: {:global, __MODULE__})

    with {:error, {:already_started, pid}} <- on_start do
      Monitor.monitor_worker(pid)
      :ignore
    end
  end

  # server
  def init(_) do
    {:ok, %{}}
  end
end
