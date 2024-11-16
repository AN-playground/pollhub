defmodule Pollhub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PollhubWeb.Telemetry,
      # Start the Ecto repository
      Pollhub.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pollhub.PubSub},
      # Start Finch
      {Finch, name: Pollhub.Finch},
      # Start the Endpoint (http/https)
      PollhubWeb.Endpoint
      # Start a worker by calling: Pollhub.Worker.start_link(arg)
      # {Pollhub.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pollhub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PollhubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
