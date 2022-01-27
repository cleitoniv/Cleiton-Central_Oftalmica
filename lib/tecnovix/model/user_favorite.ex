defmodule Tecnovix.UserFavoriteModel do
  use Tecnovix.DAO, schema: Tecnovix.UserFavoriteSchema

  alias Tecnovix.Repo

  def create(%{"user_id" => user_id, "group" => group} = params) do
    case __MODULE__.get_by([group: group, user_id: user_id]) do
      nil -> Repo.insert(%Tecnovix.UserFavoriteSchema{}, params)
      v -> {:ok, v}
    end
  end
end
