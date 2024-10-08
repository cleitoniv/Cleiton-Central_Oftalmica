defmodule Tecnovix.MixProject do
  use Mix.Project

  def project do
    [
      app: :tecnovix,
      version: "0.1.0",
      elixir: "~> 1.14.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tecnovix.Application, []},
      extra_applications: [:logger, :runtime_tools, :scrivener_ecto]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.2"},
      {:phoenix_pubsub, "~> 2.0.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, "~> 0.14"},
      {:scrivener_ecto, "~> 2.0"},
      {:dataloader, "~> 1.0"},
      {:httpoison, "~> 1.6"},
      {:jose, "~> 1.9"},
      {:bcrypt_elixir, "~> 2.0"},
      {:guardian, "~> 2.0"},
      {:bamboo, "~> 1.5"},
      {:cors_plug, "~> 1.5"},
    #   {:tesla, "~> 1.3.0"},
      {:decimal, "~> 2.0", override: true},
      {:ets, "~> 0.8.1"},
      {:credo, "~> 1.5", only: [:test, :dev], runtime: false},
      {:doctor, "~> 0.17.0", only: [:test, :dev], runtime: false},
      {:git_hooks, "~> 0.4.0", only: [:test, :dev], runtime: false}
        ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
