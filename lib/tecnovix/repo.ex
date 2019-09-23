defmodule Tecnovix.Repo do
  use Ecto.Repo,
    otp_app: :tecnovix,
    adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 20
end
