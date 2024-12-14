defmodule PointTest do
  use ExUnit.Case

  test "updatingPoint" do
    assert %Point{x: 2, y: 2} == Point.update_point(%Point{x: 1, y: 2}, 1.0, :x)
  end
end
