defmodule Methods.Linear.Test do

  use ExUnit.Case
  doctest Methods.Linear

  test "full_interpolation" do

    started_point = %Point{x: 1.3, y: 4}
    finish_point = %Point{x: 5, y: 7}

    result = Methods.Linear.apply({started_point, finish_point})

    expected = [
      %Point{x: 1.3, y: 4},
      %Point{x: 1.8, y: 4.405405405405405},
      %Point{x: 2.3, y: 4.8108108108108105},
      %Point{x: 2.8, y: 5.216216216216216},
      %Point{x: 3.3, y: 5.621621621621621},
      %Point{x: 3.8, y: 6.027027027027026},
      %Point{x: 4.3, y: 6.4324324324324325},
      %Point{x: 4.8, y: 6.837837837837838}
    ]

    assert result == expected

  end
end
