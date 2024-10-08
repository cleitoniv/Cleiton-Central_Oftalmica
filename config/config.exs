# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tecnovix,
  ecto_repos: [Tecnovix.Repo]

config :ssl, protocol_version: :"tlsv1.2"

# Configures the endpoint
config :tecnovix, TecnovixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kiE/ehf+enHNN5krrOjDp0uTdWyryxB6aG5a798ywjuAReLSH4+y8gnxDyiiQwo8",
  render_errors: [view: TecnovixWeb.ErrorView, accepts: ~w(html json)]
  # pubsub: [name: Tecnovix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tecnovix, :remetente, "victorlokiinho@gmail.com"

config :tecnovix, Tecnovix.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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"

# api_key: "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"

# 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

config :gettext, :default_locale, "pt_BR"

config :tecnovix, Tecnovix.Gettext, default_locale: "pt_BR"

# config :tecnovix, :central_endpoint, "10.101.109.1:8080"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
