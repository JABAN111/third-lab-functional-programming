defprotocol Methods.InterpolationProtocol do
  def apply(method, step, points)

  def method_name(value)

  def required_points(value)
end
