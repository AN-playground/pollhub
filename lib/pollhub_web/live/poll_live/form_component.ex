defmodule PollhubWeb.PollLive.FormComponent do
  use PollhubWeb, :live_component
  import Phoenix.HTML.Form
  import Phoenix.HTML

  alias Pollhub.Polls
  alias Pollhub.Repo
  alias Pollhub.Polls.Poll
  alias Pollhub.Polls.Entry

  @impl true
  def update(%{poll: %Poll{id: nil}} = assigns, socket) do
    IO.inspect(assigns, label: "DEBUG: Poll in FormComponent (nil)")

    poll_attrs = %{name: "New Poll", entries: []}

    case Polls.create_poll(poll_attrs) do
      {:ok, poll} ->
        # Preload entries to avoid Ecto.Association.NotLoaded
        poll = Repo.preload(poll, :entries)
        changeset = Polls.change_poll(poll)
        form = to_form(changeset)

        entries_changesets = Enum.map(poll.entries, &Polls.change_entry/1)

        IO.inspect(changeset, label: "DEBUG: Changeset at end of FormComponent (nil)")
        IO.inspect(form, label: "DEBUG: Form at end of FormComponent (nil)")

        {:ok, assign(socket, assigns |> Map.put(:form, form) |> Map.put(:entries_changesets, entries_changesets) |> Map.put_new(:new_entry, ""))}

      {:error, changeset} ->
        form = to_form(changeset)
        IO.inspect(changeset, label: "DEBUG: Changeset in error case of FormComponent (nil)")
        {:ok, assign(socket, assigns |> Map.put(:form, form))}
    end
  end

  @impl true
  def update(%{poll: %Poll{id: _}} = assigns, socket) do
    IO.inspect(assigns, label: "DEBUG: Poll in FormComponent (existing)")

    poll = assigns.poll
    changeset = Polls.change_poll(poll)

    if is_nil(poll.entries) do
      poll = Repo.preload(poll, :entries)
    end

    entries_changesets = Enum.map(poll.entries, &Polls.change_entry/1)

    form = to_form(changeset)

    IO.inspect(form, label: "DEBUG: Form at end of update/2")

    {:ok, assign(socket, assigns |> Map.put(:form, form) |> Map.put(:entries_changesets, entries_changesets) |> Map.put_new(:new_entry, ""))}
  end

  @impl true
  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset =
      socket.assigns.poll
      |> Polls.change_poll(poll_params)
      |> Map.put(:action, :validate)

    form = to_form(changeset)

    {:noreply, assign(socket, changeset: changeset, form: form)}
  end

  def handle_event("save", %{"poll" => poll_params}, socket) do
    save_poll(socket, socket.assigns.action, poll_params)
  end

  def handle_event("add_entry", %{"new_entry" => new_entry}, socket) do
    case new_entry do
      nil ->
        {:noreply, put_flash(socket, :error, "Entry cannot be empty.")}

      "" ->
        {:noreply, put_flash(socket, :error, "Entry cannot be empty.")}

      new_entry ->
        poll = socket.assigns.poll
        new_entry_struct = %Pollhub.Polls.Entry{title: new_entry, poll_id: poll.id}

        {:ok, updated_poll} = Polls.add_entry_to_poll(poll, new_entry_struct)

        updated_poll = Repo.preload(updated_poll, :entries)
        entries_changesets = Enum.map(updated_poll.entries, &Polls.change_entry(&1))

        {:noreply, assign(socket, poll: updated_poll, entries_changesets: entries_changesets, new_entry: "")}
    end
  end

  def handle_event("update_new_entry", %{"new_entry" => new_entry}, socket) do
    {:noreply, assign(socket, new_entry: new_entry)}
  end

  defp save_poll(socket, :edit, poll_params) do
    entries_params = collect_entries_params(socket.assigns.entries_changesets)

    poll_params = Map.put(poll_params, "entries", entries_params)

    case Polls.update_poll(socket.assigns.poll, poll_params) do
      {:ok, poll} ->
        poll = Repo.preload(poll, :entries)
        send(self(), {__MODULE__, {:saved, poll}})
        {:noreply, socket |> put_flash(:info, "Poll updated successfully.") |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset, form: to_form(changeset))}
    end
  end

  defp save_poll(socket, :new, poll_params) do
    entries_params = collect_entries_params(socket.assigns.entries_changesets)

    poll_params = Map.put(poll_params, "entries", entries_params)

    case Polls.create_poll(poll_params) do
      {:ok, poll} ->
        poll = Repo.preload(poll, :entries)
        send(self(), {__MODULE__, {:saved, poll}})
        {:noreply, socket |> put_flash(:info, "Poll created successfully.") |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset, form: to_form(changeset))}
    end
  end

  defp collect_entries_params(entries_changesets) do
    Enum.map(entries_changesets || [], fn entry_changeset ->
      %{
        "title" => Ecto.Changeset.get_field(entry_changeset, :title)
      }
    end)
  end
end
