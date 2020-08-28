defmodule TecnovixWeb.PedidosDeVendaView do
  use Tecnovix.Resource.View, model: Tecnovix.PedidosDeVendaModel
  import TecnovixWeb.ErrorParserView

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

  multi_parser("pedidos.json", [:filial, :cliente, :cliente_id])

  def render("pedidos.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
