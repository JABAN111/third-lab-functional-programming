defmodule ThirdLabFunctionalProgrammingTest do
  use ExUnit.Case
  doctest ThirdLabFunctionalProgramming

  test "greets the world" do
    assert ThirdLabFunctionalProgramming.hello() == :world
  end
end
