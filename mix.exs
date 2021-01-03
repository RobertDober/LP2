defmodule Lp2.MixProject do
  use Mix.Project

  @deps [
    # {:credo, "~> 0.10", only: [:dev, :test]},
    {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
    # {:earmark_ast_dsl, "~> 0.2.5", only: [:test]},
    {:excoveralls, "~> 0.13.3", only: [:test]},
    # {:floki, "~> 0.21", only: [:dev, :test]}
  ]

  def project do
    [
      app: :lp2,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: @deps,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end


  defp elixirc_paths(:test), do: ["lib", "test/support"]
  # defp elixirc_paths(:dev), do: ["lib", "bench", "dev"]
  defp elixirc_paths(_), do: ["lib"]
end
