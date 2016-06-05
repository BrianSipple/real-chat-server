defmodule RealChat.UserView do
  use RealChat.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, RealChat.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, RealChat.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
        "type": "user",
        "id": user.id,
        "attributes": %{
            "email": user.email
        }
    }
  end
end
