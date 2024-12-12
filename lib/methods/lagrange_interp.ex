defmodule Methods.LagrangeInterp do
  @moduledoc """
  Module for performing Lagrange interpolation.
  """

  alias Point

  @doc """
  Returns a list of points, where each point is interpolated using the Lagrange method.
  The step parameter specifies the step between the x values of the points.

  ## Examples

  ### Ошибка при недостаточном числе точек

      iex> alias Methods.LagrangeInterp
      iex> alias Point
      iex> points = [
      ...>   Point.new(0.0, 1.0),
      ...>   Point.new(1.0, 2.0)
      ...> ]
      iex> step = 0.5
      iex> LagrangeInterp.apply(step, points)
      {:error, "At least four points are required for Lagrange interpolation"}

  ### Вычисление значения интерполяции в конкретной точке

      iex> alias Methods.LagrangeInterp
      iex> alias Point
      iex> points = [
      ...> Point.new(1.3, 4),
      ...> Point.new(2, 7),
      ...> Point.new(3, 10),
      ...> Point.new(5.3, 14)
      ...> ]
      iex> step = 1.5
      iex> LagrangeInterp.apply(step, points)
      [
      %Point{x: 1.3, y: 4},
      %Point{x: 2.8, y: 9.498555153286611},
      %Point{x: 4.3, y: 12.477845683728038}
      ]
  """

  @spec apply(float(), list(Point.t())) :: list(Point.t()) | {:error, String.t()}
  def apply(step \\ 0.5, points) do
    IO.inspect(
      points,
      label: "points"
    )
    if Enum.count(points) < 4 do
      {:error, "At least four points are required for Lagrange interpolation"}
    else
      started_point = Enum.at(points, 0)
      finishing_point = Enum.at(points, -1) # expecting %Point{x: 5, y: 7}

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
