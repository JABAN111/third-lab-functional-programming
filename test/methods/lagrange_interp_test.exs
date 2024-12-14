defmodule Methods.Lagrange.Test do
  alias Methods.LagrangeInterp
  alias Methods.InterpolationProtocol
  alias Point

  use ExUnit.Case

  doctest Methods.InterpolationProtocol

  test "apply/2 with less than 4 points" do
    points = [
      Point.new(0.0, 1.0),
      Point.new(1.0, 2.0)
    ]

    step = 0.5

    assert InterpolationProtocol.apply(%LagrangeInterp{}, step, points) ==
             {:error, "At least four points are required for Lagrange interpolation"}
  end

  test "apply/2 with valid points" do
    points = [
      Point.new(1.3, 4),
      Point.new(2, 7),
      Point.new(3, 10),
      Point.new(5.3, 14)
    ]

    step = 1.5

    result = InterpolationProtocol.apply(%LagrangeInterp{}, step, points)

    assert result == [
             %Point{x: 1.3, y: 4},
             %Point{x: 2.8, y: 9.498555153286611},
             %Point{x: 4.3, y: 12.477845683728038}
           ]
  end
end
