defmodule InterSuperVisor do
  @moduledoc """
  Interpolation supervisor.
  """
  alias Methods.InterpolationProtocol

  use Supervisor

  @spec start_link(%{:methods => any(), :step => any(), optional(any()) => any()}) ::
          :ignore | {:error, any()} | {:ok, pid()}
  def start_link(%{methods: method, step: step}) do
    Supervisor.start_link(__MODULE__, %{methods: method, step: step}, name: __MODULE__)
  end

  @impl true
  def init(config) do
    children =
      Enum.map(
        config.methods,
        fn method ->
          Supervisor.child_spec(
            {Interpolator, %{methods: method, step: config.step}},
            id: InterpolationProtocol.method_name(method)
          )
        end
      )

    Supervisor.init(children, strategy: :one_for_one)
  end
end
