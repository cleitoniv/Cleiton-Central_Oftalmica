use Mix.Config

# Configure your database
config :tecnovix, Tecnovix.Repo,
  username: "postgres",
  password: "vitinho01",
  database: "tecnovix_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :tecnovix, TecnovixWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.

config :tecnovix, TecnovixWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/tecnovix_web/{live,views}/.*(ex)$",
      ~r"lib/tecnovix_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :tecnovix, :central_endpoint, "https://hom.app.centraloftalmica.com:8080"

config :tecnovix, :wirecard_endpoint, "https://sandbox.moip.com.br/v2/"

config :tecnovix, :moip_access_token, "6dbff0e585964b018e77030a4d039b5a_v2"
config :tecnovix, :salt, "SALT"
config :tecnovix, :firebase_api_key_client, "AIzaSyDz9lMXSUtxLxUHRdzl1G47VtlOpCa_ynM"
config :tecnovix, :firebase_api_key_vendor, "AIzaSyAw-mBe2kkFmslL0ryrgYY0_9jIbKWWkJQ"
config :tecnovix, :central_endpoint, "https://hom.app.centraloftalmica.com:8080"

config :tecnovix, :protheus_username, "TECNOVIX"
config :tecnovix, :protheus_password, "TecnoVix200505"

config :tecnovix, :central_endpoint, "http://hom.app.centraloftalmica.com:8080"

config :tecnovix,
       :sync_users_salt,
       "B9cwPTrRRrk/W+4psbuf2AI7Z6G/ncMDdunFXp52LqpwgiBTVUCYyBbjbre90S2v"

config :tecnovix, :protheus_username, "TECNOVIX"
config :tecnovix, :protheus_password, "TecnoVix200505"

config :tecnovix, Tecnovix.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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"

config :tecnovix, :central_endpoint, "https://hom.app.centraloftalmica.com:8080"
