defmodule ThirdLabFunctionalProgramming do

  @moduledoc """
  Main module for the third lab.
  """

  alias Utils.Writer
  alias Utils.Reader
  alias Methods.InterpolationProtocol

  def call_interpolation_method(pid, method, points) do
    points_required = InterpolationProtocol.required_points(method)
    points_for_method = Enum.take(points, -points_required)

    case Interpolator.interpolate(pid, points_for_method) do
      :nop ->
        nil

      result ->
        IO.puts(InterpolationProtocol.method_name(method))
        Writer.print_points(result)
    end

    Interpolator.interpolate(pid, points)
  end

  def loop(config, pid, points) do
    Enum.each(
      config.methods,
      fn method ->
        name = InterpolationProtocol.method_name(method)
        piid = SupervisorUtil.find_child_by_child_id(pid, name)

        case piid do
          nil -> nil
          pid -> call_interpolation_method(pid, method, points)
        end
      end
    )

    case Reader.read_point() do
      {:ok, point} ->
        loop(config, pid, points ++ [point])

      {:error, _} ->
        nil
    end
  end

  def run(config, pid) do
    with {:ok, p1} <- Reader.read_point(),
         {:ok, p2} <- Reader.read_point() do
      points = [p1, p2]
      loop(config, pid, points)
      :ok
    else
      _ ->
        IO.puts(:stderr, "failed to parse 2 initial points")
        :fail
    end
  end

  def main(args) do
    config = Reader.argument_reader(args)

    {:ok, pid} = InterSuperVisor.start_link(config)

    run(config, pid)
  end
end
