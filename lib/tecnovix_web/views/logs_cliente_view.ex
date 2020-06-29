defmodule TecnovixWeb.LogsClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.LogsClienteModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      uid: item.uid,
      usuario_cliente_id: item.usuario_cliente_id,
      data: item.data,
      ip: item.ip,
      dispositivo: item.dispositivo,
      acao_realizada: item.acao_realizada
    }
  end
end
