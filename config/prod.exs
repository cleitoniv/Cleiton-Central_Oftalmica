use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :tecnovix, TecnovixWeb.Endpoint,
  url: [schema: "https", host: "example.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# cache_static_manifest: "priv/static/cache_manifest.json"

config :ssl, protocol_version: :"tlsv1.2"

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :tecnovix, TecnovixWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :tecnovix, TecnovixWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

config :tecnovix, :wirecard_endpoint, "https://sandbox.moip.com.br/v2/"

config :tecnovix, :moip_access_token, "6dbff0e585964b018e77030a4d039b5a_v2"
config :tecnovix, :salt, "SALT"
config :tecnovix, :firebase_api_key_client, "AIzaSyADayA3jTgwWee7_3C2h4YSTo6nScuAQaI"
config :tecnovix, :firebase_api_key_vendor, "AIzaSyAw-mBe2kkFmslL0ryrgYY0_9jIbKWWkJQ"

config :tecnovix,
       :sync_users_salt,
       "B9cwPTrRRrk/W+4psbuf2AI7Z6G/ncMDdunFXp52LqpwgiBTVUCYyBbjbre90S2v"

config :tecnovix, :central_endpoint, "http://hom.app.centraloftalmica.com:8080"

config :tecnovix, :protheus_username, "TECNOVIX"
config :tecnovix, :protheus_password, "TecnoVix200505"
# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"
