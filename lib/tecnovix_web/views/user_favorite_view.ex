defmodule TecnovixWeb.UserFavoriteView do
  use Tecnovix.Resource.View, model: Tecnovix.UserFavoriteModel

  def build(%{item: item}) do
    %{
      id: item.id,
      user_id: item.user_id,
      group: item.group
    }
  end
end
