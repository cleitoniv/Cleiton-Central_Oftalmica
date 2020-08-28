defmodule TecnovixWeb.NotificacoesView do
  use Tecnovix.Resource.View, model: Tecnovix.NotificacoesClienteModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      data: item.data,
      titulo: item.titulo,
      descricao: item.descricao,
      enviado: item.enviado,
      lido: item.lido,
      tipo_ref: item.tipo_ref,
      tipo_ref_id: item.tipo_ref_id
    }
  end
end
