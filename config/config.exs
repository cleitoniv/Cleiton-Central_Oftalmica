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
  render_errors: [view: TecnovixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tecnovix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tecnovix, :remetente, "victorasilva0707@gmail.com"

config :tecnovix, Tecnovix.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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"

config :gettext, :default_locale, "pt_BR"

config :tecnovix, Tecnovix.Gettext, default_locale: "pt_BR"

config :tecnovix, :helpdesk_key, ["E2D49E719EEF7C76349155A4C814ADFF", "9D45C31C4FD4A1A1001EDA4083E1E69B" , "6B90D03682B09EB0390540BD38F2473B", "C9E15C5A1ECA6DAC78D96E9F7A0720D8"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
