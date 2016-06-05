defmodule RealChat.AuthErrorHandler do
  use RealChat.Web, :controller

  def unauthenticated(conn, params) do
    conn
      |> put_status(401)
      |> render(RealChat.ErrorView, "401.json")      
  end

  def unauthorized(conn, params) do
    conn
      |> put_status(403)
      |> render(RealChat.ErrorView, "403.json")
  end
end
