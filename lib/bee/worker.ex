defmodule Bee.Worker do
  use GenServer

  # client
  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  # server
  def init(_) do
    {:ok, %{}}
  end
end
