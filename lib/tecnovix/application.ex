defmodule Tecnovix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    {:ok, _kvset} = ETS.KeyValueSet.new(name: :code_confirmation, protection: :public)
    # List all child processes to be supervised
    children = [
      # {Phoenix.PubSub, [name: Tecnovix.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start the Ecto repository
      Tecnovix.Repo,
      # Start the endpoint when the application starts
      TecnovixWeb.Endpoint,
      # Starts a worker by calling: Tecnovix.Worker.start_link(arg)
      # {Tecnovix.Worker, arg},
      # {Absinthe.Subscription, [TecnovixWeb.Endpoint]},
      {Tecnovix.Services.Auth, []},
      {Tecnovix.Services.Devolucao, []},
      {Tecnovix.Services.ConfirmationSMS, []},
      {Tecnovix.Services.Order, []},
      {Tecnovix.Services.OrderFinan, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tecnovix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TecnovixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
