defmodule Pollhub.Repo.Migrations.CreateParticipations do
  use Ecto.Migration

  def change do
    create table(:participations) do
      add :poll_id, references(:polls, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:participations, [:poll_id])
    create index(:participations, [:user_id])
  end
end
