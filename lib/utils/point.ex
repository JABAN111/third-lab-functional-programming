defmodule Point do
  @moduledoc """
  Represents a point in a 2D space. And utils for working with points.
  """

  @typedoc """
    Represents a point in a 2D space.
  """
  @type(point :: float(), float())

  defstruct x: 0.0, y: 0.0

  @doc """
    returning default point view
  """
  def new() do
    %Point{}
  end

  def new(x, y) do
    %Point{x: x, y: y}
  end

  def new({:x, x}) do
    %Point{x: x}
  end

  def new({:y, y}) do
    %Point{y: y}
  end

  @doc """

  if user forget to specify which value is ignoring, then ignore y value
  same as using {x, _} tuple

    ## Examples

      iex> Point.new(1)
      %Point{x: 1.0, y: 0.0}

  """
  def new(x) do
    %Point{x: x}
  end

  @doc """
  Return updated version of point increased (or decreased) on x value.

  ## Examples

    iex> Point.update_point(%Point{x: 1, y: 2}, 1.0, :x)
    %Point{x: 2.0, y: 2}

  """
  def update_point(point, value, :x) when is_number(value) do
    %Point{x: point.x + value, y: point.y}
  end

  def update_point(point, value, :y) when is_number(value) do
    %Point{x: point.x, y: point.y + value}
  end
end

defimpl String.Chars, for: Point do
  def to_string(%Point{x: x, y: y}) do
    "(#{x}, #{y})"
  end
end
