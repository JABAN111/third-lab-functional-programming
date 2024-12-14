defmodule Utils.Writer do
  def print_points(points_list) do
    IO.puts("Points:")
    IO.inspect(points_list)
    # TODO реализовать эту историю
    # Enum.each(points_list, fn {x, y} -> IO.puts("#{x} #{y}") end)
  end
end
