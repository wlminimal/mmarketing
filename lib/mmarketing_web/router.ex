defmodule MmarketingWeb.Router do
  use MmarketingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :dashboard do
    plug MmarketingWeb.Plugs.LoadUser
    plug MmarketingWeb.Plugs.DashboardLayout
    
  end

  pipeline :loaduser do
    plug MmarketingWeb.Plugs.LoadUser
  end

  scope "/", MmarketingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/", PageController, :create_customer

    # Sign in and out
    get "/sign-in", AuthController, :new, as: :sign_in
    post "/sign-in", AuthController, :new, as: :sign_in
    get "/sign-out", AuthController, :delete, as: :sign_out
    get "/sign-in/:token", AuthController, :create, as: :sign_in
    get "/sign-up", UserController, :new,  as: :sign_up
    post "/sign-up", UserController, :create, as: :sign_up

  end

  scope "/", MmarketingWeb do
    pipe_through [:browser, :loaduser] 

    get "/phoneverify", PhoneVerifyController, :new
    post "/phoneverify", PhoneVerifyController, :create
  end

  scope "/dashboard", MmarketingWeb.Dashboard do
    pipe_through [:browser, :dashboard]

    get "/", DashboardController, :new
    get "/sms", SmsController, :new
    post "/sms", SmsController, :create

    get "/mms", MmsController, :new
    post "/mms", MmsController, :create
  end

  scope "/auth", MmarketingWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
end

  # Other scopes may use custom stacks.
  # scope "/api", MmarketingWeb do
  #   pipe_through :api
  # end
end
