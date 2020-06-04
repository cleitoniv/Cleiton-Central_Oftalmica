defmodule TecnovixWeb.SyncUsersView do
  use Tecnovix.Resource.View, model: Tecnovix.SyncUsersModel

  def build(%{item: item}) do
    %{
      id: item.id,
      username: item.username
    }
  end
end
