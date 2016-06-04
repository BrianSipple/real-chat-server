# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :real_chat, RealChat.Endpoint,
  # http: [port: {:system, "PORT"}],
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  # url: [host: "real-chat-rtc-server.herokuapp.com", port: 443],
  # secret_key_base: System.get_env("SECRET_KEY_BASE")
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [accepts: ~w(json)],
  pubsub: [name: RealChat.PubSub,
           adapter: Phoenix.PubSub.PG2]


# config :real_chat, RealChat.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   url: System.get_env("DATABASE_URL"),
#   pool_size: 20

# Do not print debug messages in production
config :logger,
  level: :info

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# The JSON-API standard requires that we handle the mime type application/vnd.api+json
config :phoenix, :format_encoders,
  "json-api": Poison

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

# Guardian config
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "RealChat",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET"),
  serializer: RealChat.GuardianSerializer




# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
