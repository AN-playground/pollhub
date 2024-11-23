defmodule Pollhub.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participations" do

    field :poll_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [])
    |> validate_required([])
  end
end
