defmodule RealChat.Router do
  use RealChat.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealChat do
    pipe_through :api
  end
end
