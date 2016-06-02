defmodule RealChat.Router do
  use RealChat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", RealChat do
    pipe_through :api
    # Route to our SessionController
    resources "session", SessionController, only: [:index]
  end
end
