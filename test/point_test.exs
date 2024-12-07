defmodule PointTest do
  use ExUnit.Case

  test "updatingPoint" do
    IO.inspect(Point.update_point(%Point{x: 1, y: 2}, 1.0, :x))
  end
end
