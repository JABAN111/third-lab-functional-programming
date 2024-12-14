defmodule Methods.Linear do

  defstruct []

  @moduledoc """
    Module for calculating linear interpolation,
    consist of one main method `apply`, which call linear interpolation for specified data
  """

  defimpl Methods.InterpolationProtocol, for: Methods.Linear do
    def method_name(_) do
      "Linear"
    end

    def required_points(_) do
      2
    end


    @spec apply(Methods.Linear.t(), float(), list()) :: list()
    def apply(_, step \\ 0.5, points) when is_list(points) do
      started_point = Enum.at(points, 0)
      finishing_point = Enum.at(points, -1)

      Stream.iterate(
        started_point,
        fn iter_point ->
          current_point = Point.update_point(iter_point, step, :x)

          new_point = interpolate({started_point, finishing_point}, current_point.x)
          new_point
        end
      )
      |> Enum.take_while(fn current_point ->
        current_point.x <= finishing_point.x
      end)
    end


    @doc """

      formula for interpolation: y = y1+(search - x1) * (y2-y1)/(x2-x1)
      where x1, y1 - coordinates of first point, x2, y2 - coordinates of second point

      ### Example:

        iex> Methods.Linear.interpolate({%Point{x: 1.3, y: 4}, %Point{x: 5, y: 7}}, 2.8)
        %Point{x: 2.8, y: 5.216216216216216}
    """
    # updated version of interpolate method
    @spec interpolate({Point.t(), Point.t()}, float()) :: Point.t()
    def interpolate({started_point, finished_point}, x_for_search) do
      right_part = (finished_point.y - started_point.y) / (finished_point.x - started_point.x)

      found_y = started_point.y + (x_for_search - started_point.x) * right_part

      Point.new(x_for_search, found_y)
    end
  end
end
