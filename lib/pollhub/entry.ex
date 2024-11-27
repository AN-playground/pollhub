defmodule Pollhub.Polls.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :title, :string
    field :votes, :integer, default: 0
    belongs_to :poll, Pollhub.Polls.Poll

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :votes, :poll_id])
    |> validate_required([:title, :poll_id])
  end
end
