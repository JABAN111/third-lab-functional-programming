defmodule Interpolator do
  @moduledoc """
  Interpolator
  """
  use GenServer
  alias Methods.InterpolationProtocol

  def interpolate(pid, points) do
    GenServer.call(pid, {:count, points})
  end

  @spec start_link(%{:methods => any(), :step => any(), optional(any()) => any()}) ::
          :ignore | {:error, any()} | {:ok, pid()}
  def start_link(%{methods: method, step: step}) do
    GenServer.start_link(__MODULE__, %{methods: method, step: step}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:count, points}, _from, state) do
    %{methods: method, step: step} = state

    n = InterpolationProtocol.required_points(method)

    if length(points) == n do
      result = InterpolationProtocol.apply(method, step, points)

      {:reply, result, state}
    else
      {:reply, :nop, state}
    end
  end
end
