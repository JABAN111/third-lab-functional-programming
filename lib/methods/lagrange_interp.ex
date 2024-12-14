defmodule Methods.LagrangeInterp do
  defstruct []

  @moduledoc """
  Module for performing Lagrange interpolation.
  Returns a list of points, where each point is interpolated using the Lagrange method.
  The step parameter specifies the step between the x values of the points.
  """

  defimpl Methods.InterpolationProtocol, for: Methods.LagrangeInterp do
    alias Point

    @spec method_name(%Methods.LagrangeInterp{}) :: <<_::64>>
    def method_name(_) do
      "lagrange"
    end

    def required_points(_) do
      4
    end

    @spec apply(%Methods.LagrangeInterp{}, float(), list(Point.t())) ::
            list(Point.t()) | {:error, String.t()}
    def apply(_, step \\ 0.5, points) do
      if Enum.count(points) < 4 do
        {:error, "At least four points are required for Lagrange interpolation"}
      else
        started_point = Enum.at(points, 0)
        # expecting %Point{x: 5, y: 7}
        finishing_point = Enum.at(points, -1)

        Stream.iterate(
          started_point,
          fn %Point{x: x, y: _} ->
            %Point{x: x + step, y: interpolate(points, x + step)}
          end
        )
        |> Enum.take_while(fn %Point{x: x} -> x <= finishing_point.x end)
      end
    end

    @spec interpolate(list(Point.t()), float()) :: float()
    def interpolate(points, x_for_search) do
      Enum.reduce(
        points,
        0.0,
        fn %Point{x: x1, y: y1}, acc ->
          # Вычисление базисного полинома
          q =
            Enum.reduce(
              points,
              1.0,
              fn %Point{x: xj}, q_acc ->
                if x1 == xj do
                  q_acc
                else
                  q_acc * (x_for_search - xj) / (x1 - xj)
                end
              end
            )

          acc + y1 * q
        end
      )
    end
  end
end
