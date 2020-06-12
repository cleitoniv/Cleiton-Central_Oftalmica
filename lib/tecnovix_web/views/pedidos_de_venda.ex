defmodule TecnovixWeb.PedidosDeVendaView do
  use Tecnovix.Resource.View, model: Tecnovix.PedidosDeVendaModel

    def build(%{item: item}) do
      %{
        cliente_id: item.cliente_id,
        filial: item.filial,
        numero: item.numero,
        cliente: item.cliente,
        tipo_venda: item.tipo_venda,
        tipo_venda_ret_id: item.tipo_venda_ret_id,
        pd_correios: item.pd_correios,
        vendedor_1: item.vendedor_1,
        status_ped: item.status_ped
      }
    end
end
