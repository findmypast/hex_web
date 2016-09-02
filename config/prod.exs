use Mix.Config

config :hex_web, HexWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("HEX_URL"), scheme: "https", port: 443],
  force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: {:system, "HEX_SECRET_KEY_BASE"}

config :hex_web, HexWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: 20

config :comeonin,
  bcrypt_log_rounds: 12

config :rollbax,
  access_token: System.get_env("ROLLBAR_ACCESS_TOKEN"),
  environment: to_string(Mix.env),
  enabled: false

config :logger,
  backends: [Rollbax.Logger, :console]

config :logger, Rollbax.Logger,
  level: :error

# Don't include date time on heroku
config :logger, :console,
  format: "[$level] $message\n"

config :logger,
  level: :warn
