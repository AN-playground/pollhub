defmodule Pollhub.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :name, :string

      timestamps()
    end
  end
end
