defmodule Utils.Reader do
  @moduledoc """
  Module for reading points from the console.
  """

  alias Methods.Linear
  alias Methods.LagrangeInterp

  def argument_reader(args) when is_list(args) do
    options_spec = [
      step: :float,
      linear: :boolean,
      lagrange: :boolean
    ]

    {parsed_opts, _, _} = OptionParser.parse(args, switches: options_spec)

    step = Keyword.get(parsed_opts, :step, 1.5)
    linear = Keyword.get(parsed_opts, :linear, false)
    lagrange = Keyword.get(parsed_opts, :lagrange, false)

    methods =
      if lagrange do
        [%LagrangeInterp{}]
      else
        []
      end

    methods =
      if linear do
        [%Linear{} | methods]
      else
        methods
      end

    %{step: step, methods: methods}
  end

  def argument_reader(_) do
    {:error, "Invalid arguments"}
  end

  def read_point do
    case IO.gets("") do
      :eof -> :eof
      str -> parse_point(str)
    end
  end

  def parse_point(str) do
    case str
         |> String.trim()
         |> String.split(" ") do
      [raw_x, raw_y] ->
        with {:ok, x} <- parse_float!(raw_x),
             {:ok, y} <- parse_float!(raw_y) do
          {:ok, Point.new(x, y)}
        end

      _ ->
        {:error, "Invalid point format"}
    end
  end

  def parse_float!(str) do
    case Float.parse(str) do
      {float, ""} ->
        {:ok, float}

      _ ->
        raise "Invalid float format"
    end
  end

  def spin_loop() do
    IO.puts("Enter points in format x1 y1 x2 y2 x3 y3 ... xn yn")
    IO.gets("")
  end
end
