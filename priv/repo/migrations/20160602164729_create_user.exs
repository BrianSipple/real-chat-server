defmodule RealChat.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string

      timestamps
    end

    # Unique email address constraint, via DB index
    create unique_index(:users, [:email])

  end
end
