# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :agenda,
  ecto_repos: [Agenda.Repo]

# Configures the endpoint
config :agenda, AgendaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AgendaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Agenda.PubSub,
  live_view: [signing_salt: "1AbfDS3O"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :agenda, Agenda.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :dart_sass,
  version: "1.53.0",
  default: [
    args: ~w(--load-path=../deps/bulma css:../priv/static/assets),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  catalogue: [
    args:
      ~w(../deps/surface_catalogue/assets/js/app.js --bundle --target=es2016 --minify --outdir=../priv/static/assets/catalogue),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :surface, :components, [
  {Surface.Components.Form.ErrorTag,
   default_translator: {AgendaWeb.ErrorHelpers, :translate_error}}
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
