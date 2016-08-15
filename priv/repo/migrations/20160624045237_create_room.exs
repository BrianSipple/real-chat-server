defmodule RealChat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:rooms, [:owner_id])

    # Unique room names across the whole app
    # (supports implementing a corresponding model-level contraint)
    create unique_index(:rooms, [:name])
  end
end
