defmodule RealChat.Router do
  use RealChat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # Unauthenticated routes
  scope "/api/v1", RealChat do
    pipe_through :api
    # Registration
    post "register", RegistrationController, :create
    # Route to our SessionController's `create` method (and, within our code, refer to this route as "login")
    post "token", SessionController, :create, as: :login
  end

  # Authenticated routes
  scope "/api/v1", RealChat do
    pipe_through :api_auth
    # Retrieving the current user
    get "/user/current", UserController, :current
    resources "/rooms", RoomController, except: [:new, :edit]  # define a collection of routes to be used by our RoomController
  end


end
