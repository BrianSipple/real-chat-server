defmodule RealChat.UserTest do
  use RealChat.ModelCase

  alias RealChat.User

  @valid_attrs %{email: "brian@example.com",
    password: "immutability1",
    password_confirmation: "immutability1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "mis-matched password and password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{email: "brian@example.com",
      password: "google",
      password_confirmation: "gooogle"})
    refute changeset.valid?
  end

  test "missing password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{email: "brian@example.com",
      password: "google"})
    refute changeset.valid?
  end
end
