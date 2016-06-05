defmodule RealChat.UserController do
  use RealChat.Web, :controller

  alias RealChat.User
  plug Guardian.Plug.EnsureAuthenticated, handler: RealChat.AuthErrorHandler

  def current(conn, _) do
    user = conn
      |> Guardian.Plug.current_resource

    conn
      |> render(RealChat.UserView, "show.json", user: user)
  end



end
