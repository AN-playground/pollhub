defmodule PollhubWeb.PollLive.Index do
  use PollhubWeb, :live_view

  alias Pollhub.Repo
  alias Pollhub.Polls

  @impl true
  def mount(_params, _session, socket) do
    polls = Polls.list_polls() |> Repo.preload(:entries)  # Preload entries for all polls listed
    {:ok, stream(socket, :polls, polls)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = apply_action(socket, socket.assigns.live_action, params)
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Polls")
    |> assign(:poll, %Pollhub.Polls.Poll{name: "", entries: []})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Poll")
    |> assign(:poll, %Pollhub.Polls.Poll{name: "", entries: []})  # Empty entries for new poll
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    poll = Polls.get_poll!(id) |> Repo.preload(:entries)  # Preload entries for the poll you're editing
    socket
    |> assign(:page_title, "Edit Poll")
    |> assign(:poll, poll)  # Assign the poll with preloaded entries to the socket
  end

  @impl true
  def handle_info({PollhubWeb.PollLive.FormComponent, {:saved, poll}}, socket) do
    {:noreply, stream_insert(socket, :polls, poll)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    poll = Polls.get_poll!(id)
    {:ok, _} = Polls.delete_poll(poll)

    {:noreply, stream_delete(socket, :polls, poll)}
  end
end