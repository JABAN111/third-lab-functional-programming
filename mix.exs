defmodule ThirdLabFunctionalProgramming.MixProject do
  use Mix.Project

  def project do
    [
      app: :third_lab_functional_programming,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: escript(),
      # start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp escript do
    [main_module: ThirdLabFunctionalProgramming]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
