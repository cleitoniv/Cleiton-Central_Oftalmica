defmodule TecnovixWeb.AgendaView do
  use Tecnovix.Resource.View, model: Tecnovix.AgendaModel

  def build(%{item: item}) do
    %{
      id: item.id,
      date: item.date,
      temporizador: item.temporizador,
      turno_manha: item.turno_manha,
      turno_tarde: item.turno_tarde,
      visitado: item.visitado,
      cliente_id: item.cliente_id,
      vendedor_id: item.vendedor_id
    }
  end

  def render("schedule.json", %{item: item}) do
    %{
      id: item.id,
      date: item.date,
      temporizador: item.temporizador,
      turno_manha: item.turno_manha,
      turno_tarde: item.turno_tarde,
      visitado: item.visitado,
      cliente_id: item.cliente_id,
      vendedor_id: item.vendedor_id,
      bairro: item.cliente.bairro,
      cidade: item.cliente.municipio,
      estado: item.cliente.estado,
      nome: item.cliente.nome,
      numero: item.cliente.numero,
      endereco: item.cliente.endereco,
      cep: item.cliente.cep
    }
  end

  def render("schedules.json", %{item: schedules}) do
    %{
      success: true,
      data: render_many(schedules, __MODULE__, "schedule.json", as: :item)
      # |> Enum.group_by(fn schedule -> schedule.cidade end)
    }
  end
end
