defmodule RealChat.Router do
  use RealChat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", RealChat do
    pipe_through :api
    # Registration
    post "register", RegistrationController, :create
    # Route to our SessionController's `create` method (and, within our code, refer to this route as "login")
    post "token", SessionController, :create, as: :login

  end
end
