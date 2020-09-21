defmodule TecnovixWeb.RescuePointsView do
  use Tecnovix.Resource.View, model: Tecnovix.RescuePointsModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      points: item.points,
      credit_finan: item.credit_finan
    }
  end
end
