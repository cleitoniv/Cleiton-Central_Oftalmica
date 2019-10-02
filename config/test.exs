use Mix.Config

# Configure your database
config :tecnovix, Tecnovix.Repo,
  username: "postgres",
  password: "postgres",
  database: "tecnovix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tecnovix, TecnovixWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :tecnovix, :wirecard_endpoint, "https://sandbox.moip.com.br/v2/"

config :tecnovix, :moip_access_token, "6dbff0e585964b018e77030a4d039b5a_v2"

config :tecnovix, :salt, "SALT"
