defmodule Methods.Lagrange.Test do
  alias Methods.LagrangeInterp
  use ExUnit.Case
  doctest LagrangeInterp
end

  # test "interpolates a linear polynomial" do
  #   points = [Point.new(0, 0), Point.new(1, 1)]

  #   LagrangeInterp.basis_polynomial(points, 1, 0.5)
  #   # assert LagrangeInterp.interpolate(points, 0.5) == 0.5
  # end

  # test "interpolates a quadratic polynomial" do
  #   points = [{0, 0}, {1, 1}, {2, 4}]
  #   assert LagrangeInterp.interpolate(points, 1.5) == 2.25
  # end

  # test "interpolates a cubic polynomial" do
  #   points = [{0, 0}, {1, 1}, {2, 8}, {3, 27}]
  #   assert LagrangeInterp.interpolate(points, 2.5) == 15.625
  # end

  # test "interpolates a constant polynomial" do
  #   points = [{0, 5}, {1, 5}, {2, 5}]
  #   assert LagrangeInterp.interpolate(points, 1.5) == 5
  # end

  # test "interpolates with negative values" do
  #   points = [{-1, -1}, {0, 0}, {1, 1}]
  #   assert LagrangeInterp.interpolate(points, -0.5) == -0.5
  # end
# end
