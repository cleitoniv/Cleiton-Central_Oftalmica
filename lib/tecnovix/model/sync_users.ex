defmodule Tecnovix.SyncUsersModel do
  use Tecnovix.DAO, schema: Tecnovix.SyncUsersSchema
  alias Tecnovix.SyncUsersSchema
  alias Tecnovix.Repo
  import Ecto.Changeset

  def create(params) do
    %SyncUsersSchema{}
    |> change(Bcrypt.add_hash(params["password"]))
    |> SyncUsersSchema.changeset(params)
    |> Repo.insert()
  end

  def get_by_username(username) do
    case Repo.get_by(SyncUsersSchema, username: username) do
      nil -> {:error, nil}
      user -> {:ok, user}
    end
  end
end
