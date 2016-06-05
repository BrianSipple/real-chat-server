defmodule RealChat.RegistrationControllerTest do
  use RealChat.ConnCase

  alias RealChat.User

  @valid_attrs %{
    "email": "brian@example.com",
    "password": "seattle12",
    "password-confirmation": "seattle12"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    { :ok, conn: put_req_header(conn, "accept", "application/json") }
  end

  test "creating and rendering a resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), %{data: %{type: "users",
      attributes: @valid_attrs
      }}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{email: @valid_attrs[:email]})
  end

  test "not creating a resource and rendering errors when data is invalid", %{conn: conn} do
    assert_error_sent 400, fn ->
      conn = post conn, registration_path(conn, :create), %{data: %{type: "user",
        attributes: @invalid_attrs
      }}
    end
  end
end
