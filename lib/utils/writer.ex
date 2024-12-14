defmodule Utils.Writer do
  @moduledoc """
  Module for writing points to the console.
  """

  def print_points(points_list) do
    Enum.each(
      points_list,
      fn point ->
        IO.puts(point)
      end
    )
  end
end
