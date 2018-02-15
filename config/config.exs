# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mmarketing,
  ecto_repos: [Mmarketing.Repo]

# Configures the endpoint
config :mmarketing, MmarketingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AXEyOy2Nl6m3WfhXbKi/CRqKXZZeSN8aInl4HEs28QLcQhmk9ETBgxNrEvQdTyKO",
  render_errors: [view: MmarketingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mmarketing.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Change Later : Application.get_env()
config :stripity_stripe,
  secret_key: System.get_env("STRIPE_SECRET_KEY")

config :ex_twilio,
  account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token: System.get_env("TWILIO_AUTH_TOKEN")

# Bamboo
config :mmarketing, Mmarketing.Mailer,
  adapter: Bamboo.LocalAdapter

config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [display: "popup"] },
    google: { Ueberauth.Strategy.Google, [] },
    identity: { Ueberauth.Strategy.Identity, [ callback_methods: ["POST"]] },
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")


config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
