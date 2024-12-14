## Выполнил

- ФИО:`Нягин Михаил Алексеевич`
- ISU_ID:`368601`
- Группа:`P3313`

---

Цель: получить навыки работы с вводом/выводом, потоковой обработкой данных, командной строкой.
В рамках лабораторной работы вам предлагается повторно реализовать лабораторную работу по предмету "Вычислительная математика" посвящённую интерполяции (в разные годы это лабораторная работа 3 или 4) со следующими дополнениями:
обязательно должна быть реализована линейная интерполяция (отрезками, link);
настройки алгоритма интерполяции и выводимых данных должны задаваться через аргументы командной строки:

какие алгоритмы использовать (в том числе два сразу);
частота дискретизации результирующих данных;
и т.п.;


входные данные должны задаваться в текстовом формате на подобии ".csv" (к примеру x;y\n или x\ty\n) и подаваться на стандартный ввод, входные данные должны быть отсортированы по возрастанию x;
выходные данные должны подаваться на стандартный вывод;
программа должна работать в потоковом режиме (пример -- cat | grep 11), это значит, что при запуске программы она должна ожидать получения данных на стандартный ввод, и, по мере получения достаточного количества данных, должна выводить рассчитанные точки в стандартный вывод;



[Полное условие задания](https://gitlab.se.ifmo.ru/functional-programming/main/-/blob/master/laboratory-course.md#:~:text=%D0%9B%D0%B0%D0%B1%D0%BE%D1%80%D0%B0%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F%20%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%20%E2%84%963)

Описание выполнения
---
В ходе выполнения лабораторной работы был реализован алгоритм интерполяции для линейного метода:
```Elixir
defmodule Methods.Linear do

  defstruct []

  @moduledoc """
    Module for calculating linear interpolation,
    consist of one main method `apply`, which call linear interpolation for specified data
  """

  defimpl Methods.InterpolationProtocol, for: Methods.Linear do
    def method_name(_) do
      "Linear"
    end

    def required_points(_) do
      2
    end


    @spec apply(Methods.Linear.t(), float(), list()) :: list()
    def apply(_, step \\ 0.5, points) when is_list(points) do
      started_point = Enum.at(points, 0)
      finishing_point = Enum.at(points, -1)

      Stream.iterate(
        started_point,
        fn iter_point ->
          current_point = Point.update_point(iter_point, step, :x)

          new_point = interpolate({started_point, finishing_point}, current_point.x)
          new_point
        end
      )
      |> Enum.take_while(fn current_point ->
        current_point.x <= finishing_point.x
      end)
    end


    @doc """

      formula for interpolation: y = y1+(search - x1) * (y2-y1)/(x2-x1)
      where x1, y1 - coordinates of first point, x2, y2 - coordinates of second point

      ### Example:

        iex> Methods.Linear.interpolate({%Point{x: 1.3, y: 4}, %Point{x: 5, y: 7}}, 2.8)
        %Point{x: 2.8, y: 5.216216216216216}
    """
    # updated version of interpolate method
    @spec interpolate({Point.t(), Point.t()}, float()) :: Point.t()
    def interpolate({started_point, finished_point}, x_for_search) do
      right_part = (finished_point.y - started_point.y) / (finished_point.x - started_point.x)

      found_y = started_point.y + (x_for_search - started_point.x) * right_part

      Point.new(x_for_search, found_y)
    end
  end
end
```
и метода Лагранжа
```Elixir
defmodule Methods.LagrangeInterp do
  defstruct []

  @moduledoc """
  Module for performing Lagrange interpolation.
  Returns a list of points, where each point is interpolated using the Lagrange method.
  The step parameter specifies the step between the x values of the points.
  """

  defimpl Methods.InterpolationProtocol, for: Methods.LagrangeInterp do
    alias Point

    @spec method_name(Methods.LagrangeInterp.t()) :: <<_::64>>
    def method_name(_) do
      "lagrange"
    end

    def required_points(_) do
      4
    end

    @spec apply(Methods.LagrangeInterp.t(), float(), list(Point.t())) ::
            list(Point.t()) | {:error, String.t()}
    def apply(_, step \\ 0.5, points) do
      if Enum.count(points) < 4 do
        {:error, "At least four points are required for Lagrange interpolation"}
      else
        started_point = Enum.at(points, 0)
        # expecting %Point{x: 5, y: 7}
        finishing_point = Enum.at(points, -1)

        Stream.iterate(
          started_point,
          fn %Point{x: x, y: _} ->
            %Point{x: x + step, y: interpolate(points, x + step)}
          end
        )
        |> Enum.take_while(fn %Point{x: x} -> x <= finishing_point.x end)
      end
    end

    @spec interpolate(list(Point.t()), float()) :: float()
    def interpolate(points, x_for_search) do
      Enum.reduce(
        points,
        0.0,
        fn %Point{x: x1, y: y1}, acc ->
          q =
            Enum.reduce(
              points,
              1.0,
              fn %Point{x: xj}, q_acc ->
                if x1 == xj do
                  q_acc
                else
                  q_acc * (x_for_search - xj) / (x1 - xj)
                end
              end
            )

          acc + y1 * q
        end
      )
    end
  end
end
```

Оба метода являются имплементацией протокола InterpolationProtocol
```Elixir
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
```

Был написан супервизор:
```Elixir
defmodule InterSuperVisor do
  @moduledoc """
  Interpolation supervisor.
  """
  alias Methods.InterpolationProtocol

  use Supervisor

  @spec start_link(%{:methods => any(), :step => any(), optional(any()) => any()}) ::
          :ignore | {:error, any()} | {:ok, pid()}
  def start_link(%{methods: method, step: step}) do
    Supervisor.start_link(__MODULE__, %{methods: method, step: step}, name: __MODULE__)
  end

  @impl true
  def init(config) do
    children =
      Enum.map(
        config.methods,
        fn method ->
          Supervisor.child_spec(
            {Interpolator, %{methods: method, step: config.step}},
            id: InterpolationProtocol.method_name(method)
          )
        end
      )

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

И GenServer:

```Elixir
defmodule Interpolator do
  @moduledoc """
  Interpolator
  """
  use GenServer
  alias Methods.InterpolationProtocol

  def interpolate(pid, points) do
    GenServer.call(pid, {:count, points})
  end

  @spec start_link(%{:methods => any(), :step => any(), optional(any()) => any()}) ::
          :ignore | {:error, any()} | {:ok, pid()}
  def start_link(%{methods: method, step: step}) do
    GenServer.start_link(__MODULE__, %{methods: method, step: step}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:count, points}, _from, state) do
    %{methods: method, step: step} = state

    n = InterpolationProtocol.required_points(method)

    if length(points) == n do
      result = InterpolationProtocol.apply(method, step, points)

      {:reply, result, state}
    else
      {:reply, :nop, state}
    end
  end
end
```
Из еще интересного -- парсер аргументов при запуске программы вида:
```bash
./programm_name --lagrange --step=0.5
```
Его реализация:
```Elixir
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
```

Сборка и запуск
---

Для сборки программы в исполняемый файл необходимо выполнить:
```bash
mix escript.build
```

Для заапуска
```bash
./third_lab_functional_programming --step=1.5 --linear --lagrange
```
В случае отсутствия одного из флагов, будет выполнен только один метод

### ход программы:
`./third_lab_functional_programming --step=1.5 --linear --lagrange`
```
2 5 #ввел пользователь
5 8 #ввел пользователь
Linear
(2.0, 5.0)
(3.5, 6.5)
(5.0, 8.0)
7 9 #ввел пользователь
10 11 #ввел пользователь

lagrange
(2.0, 5.0)
(3.5, 6.856249999999999)
(5.0, 8.0)
(6.5, 8.76875)
(8.0, 9.499999999999998)
(9.5, 10.53125)

```