defprotocol Methods.InterpolationProtocol do

  alias Point

  @doc """
    return list of points, list consist of points starting from started_point.x and stepping it
    until it less than finishing_point.x. For each x is interpolating the value of y

    ### Example:
      iex> Methods.Linear.apply(1.5, [%Point{x: 1.3, y: 4}, %Point{x: 5, y: 7}])
      [%Point{x: 1.3, y: 4}, %Point{x: 2.8, y: 5.216216216216216}, %Point{x: 4.3, y: 6.4324324324324325}]
  """
  @spec apply(method :: atom(), step :: float(), points :: list(Point.t())) ::
          list(Point.t()) | {:error, String.t()}
  def apply(method, step, points)

  def method_name(value)

  def required_points(value)
end
