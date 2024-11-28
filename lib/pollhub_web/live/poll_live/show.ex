defmodule PollhubWeb.PollLive.Show do
  use PollhubWeb, :live_view

  alias Pollhub.Repo
  alias Pollhub.Polls

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    poll = Polls.get_poll!(id) |> Repo.preload(:entries)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:poll, Polls.get_poll!(id))}
  end

  defp page_title(:show), do: "Show Poll"
  defp page_title(:edit), do: "Edit Poll"
end
