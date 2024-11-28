defmodule Pollhub.Polls do

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Pollhub.Repo
  alias Pollhub.Polls.{Poll, Entry}

  def list_polls do
    Repo.all(Poll)
    |> Repo.preload(:entries)
  end

  def get_poll!(id) do
    Poll
    |> Repo.get!(id)
    |> Repo.preload(:entries)
  end

  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
    |> case do
         {:ok, poll} ->
           poll = Repo.preload(poll, :entries)
           {:ok, poll}

         {:error, changeset} ->
           {:error, changeset}
       end
  end

  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    IO.inspect(attrs, label: "DEBUG: Attributes passed to change_poll")
    poll
    |> cast(attrs, [:name])
    |> cast_assoc(:entries, with: &Entry.changeset/2, required: false)
    |> validate_required([:name])
  end

  def add_entry_to_poll(%Poll{} = poll, entry_attrs) do
    %Entry{}
    |> Entry.changeset(Map.put(entry_attrs, :poll_id, poll.id))
    |> Repo.insert()
  end

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    entry
    |> cast(attrs, [:title, :votes, :poll_id])
    |> validate_required([:title])
  end
end
