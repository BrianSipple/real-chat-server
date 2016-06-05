defmodule RealChat.RegistrationController do
  use RealChat.Web, :controller

  alias RealChat.User

  def create(conn, %{"data" => %{"type" => "users",
    "attributes" => %{"email" => email,
      "password" => password,
      "password-confirmation" => password_confirmation}}}) do

    changeset = User.changeset %User{}, %{email: email,
      password: password,
      password_confirmation: password_confirmation
    }

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(RealChat.UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RealChat.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
