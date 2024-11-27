defmodule Pollhub.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pollhub.Repo

  schema "polls" do
    field :name, :string, default: ""
    has_many :entries, Pollhub.Polls.Entry
    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    IO.inspect(attrs, label: "DEBUG: Attributes passed to changeset")

    poll
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> preload_entries()
    |> cast_assoc(:entries, with: &Pollhub.Polls.Entry.changeset/2, required: false)
    |> Map.update(:entries, [], fn entries -> entries || [] end)
  end

  defp preload_entries(changeset) do
    IO.inspect(changeset, label: "DEBUG: Changeset at start of preload entries")
    poll = changeset.data

    if poll.id do
      changeset
      |> Repo.preload(:entries)
    else
      changeset
    end
  end

  def change_poll(poll, attrs) do
    poll
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
