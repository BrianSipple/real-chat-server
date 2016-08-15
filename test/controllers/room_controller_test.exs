defmodule RealChat.RoomControllerTest do
  use RealChat.ConnCase

  alias RealChat.Room
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  defp create_test_rooms(user) do
    # Create three rooms owned by the logged in user
    Enum.each ["The Spell Room", "The Elixir Room", "Random Room"], fn name ->
      Repo.insert! %Room{owner_id: user.id, name: name}
    end

    # Create two rooms owned by another user
    other_user = Repo.insert! %RealChat.User{}

    Enum.each ["Elixir Training", "Elixir Secrets"], fn name ->
      Repo.insert! %Room{owner_id: other_user.id, name: name}
    end
  end


  # Effectively log in a test user before every test
  setup %{conn: conn} do
    # Create a user (bypasses validation
    user = Repo.insert! %RealChat.User{}

    # Encode a token for the user
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")
    |> put_req_header("authorization", "Bearer #{jwt}") # Add token to auth header

    {:ok, %{conn: conn, data: user}} # Pass user object to each test
  end


  test "lists all entries on index", %{conn: conn, data: user} do
    # build test rooms
    create_test_rooms user

    # List all rooms
    conn = get conn, room_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "lists owned entries on index (owner_id = user id)", %{conn: conn, data: user} do
    create_test_rooms user

    conn = get conn, room_path(conn, :index, user_id: user.id)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  test "shows chosen resource", %{conn: conn, data: user} do
    room = Repo.insert! %Room{owner_id: user.id, name: "Red Room"}
    conn = get conn, room_path(conn, :show, room)

    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(room.id),
      "type" => "room",
      "attributes" => %{
        "name" => room.name
      },
      "relationships" => %{
        "owner" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/v1/user/#{user.id}"
          }
        }
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, data: user} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, data: user} do
    conn = post conn, room_path(conn, :create), data: %{
      type: "rooms",
      attributes: @valid_attrs,
      relationships: %{}
    }
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, data: user} do
    conn = post conn, room_path(conn, :create), data: %{
      type: "rooms",
      attributes: @invalid_attrs,
      relationships: %{}
    }
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, data: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = put conn, room_path(conn, :update, room), data: %{
      id: room.id,
      type: "rooms",
      attributes: @valid_attrs
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = put conn, room_path(conn, :update, room), data: %{
      id: room.id,
      type: "rooms",
      attributes: @invalid_attrs
    }
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, data: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = delete conn, room_path(conn, :delete, room)
    assert response(conn, 204)
    refute Repo.get(Room, room.id)
  end

end
