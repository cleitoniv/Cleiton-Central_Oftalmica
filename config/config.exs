# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tecnovix,
  ecto_repos: [Tecnovix.Repo]

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

config :tecnovix, :firebase_api_key_client, "AIzaSyB48TsW9wZvwqfclaygSlW83WXNukqR45o"
config :tecnovix, :firebase_api_key_vendor, "AIzaSyAw-mBe2kkFmslL0ryrgYY0_9jIbKWWkJQ"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
