defmodule Pollhub.Repo do
  use Ecto.Repo,
    otp_app: :pollhub,
    adapter: Ecto.Adapters.Postgres
end
