defmodule Tecnovix.UserFavoriteModel do
  use Tecnovix.DAO, schema: Tecnovix.UserFavoriteSchema

  alias Tecnovix.Repo
  import Ecto.Query

  def create(%{"user_id" => user_id, "group" => group} = params) do
    case __MODULE__.get_by([group: group, user_id: user_id]) do
      nil ->
        %Tecnovix.UserFavoriteSchema{}
        |> Tecnovix.UserFavoriteSchema.changeset(params)
        |> Repo.insert()
      v ->
        __MODULE__.delete(v) 
        {:ok, v}
    end
  end

  def get_favorites(user_id) do
    Tecnovix.UserFavoriteSchema
    |> where([uf], uf.user_id == ^user_id)
    |> Repo.all()
  end

  def user_id_filter(params) do
    dynamic([uf], uf.user_id == ^params["user_id"])
  end
end
