Code.load_file("test/helpers/wirecard_helper.exs")
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Tecnovix.Repo, :manual)
