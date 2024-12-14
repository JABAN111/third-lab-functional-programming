defprotocol Methods.InterpolationProtocol do

  alias Point

  @doc """
    return list of points, list consist of points starting from started_point.x and stepping it
    until it less than finishing_point.x. For each x is interpolating the value of y

  """
  @spec apply(method :: atom(), step :: float(), points :: list(Point.t())) ::
          list(Point.t()) | {:error, String.t()}
  def apply(method, step, points)

  def method_name(value)

  def required_points(value)
end
