defmodule Tecnovix.Repo do
  use Ecto.Repo,
    otp_app: :tecnovix,
    adapter: Ecto.Adapters.Postgres
end
