defmodule Tecnovix.Repo do
  use Ecto.Repo,
    otp_app: :tecnovix,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20

  def current_time() do
    {:ok, dt} = DateTime.now("Etc/UTC")
    DateTime.truncate(dt, :second)
  end

  def generate_event_id() do
    {:ok, date} = DateTime.now("Etc/UTC")

    "#{date.year}#{date.month}#{date.day}#{date.second}#{String.slice(Ecto.UUID.autogenerate(), 0..5)}"
  end
end
