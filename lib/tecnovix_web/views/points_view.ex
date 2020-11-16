defmodule TecnovixWeb.PointsView do
  use Tecnovix.Resource.View, model: Tecnovix.PointsModel

  def build(%{item: item}) do
    %{
      num_serie: item.num_serie,
      paciente: item.paciente,
      num_pac: item.num_pac,
      dt_nas_pac: item.dt_nas_pac,
      points: item.points,
      credit_finan: item.credit_finan,
      status: item.status,
      success: true
    }
  end
end
