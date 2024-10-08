defmodule TecnovixWeb.PedidosDeVendaView do
  use Tecnovix.Resource.View, model: Tecnovix.PedidosDeVendaModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      data: %{
        id: item.id,
        client_id: item.client_id,
        order_id: item.order_id,
        tipo_pagamento: item.tipo_pagamento,
        parcela: item.parcela,
        loja: item.loja,
        integrado: item.integrado,
        cliente: item.cliente,
        tipo_venda_ret_id: item.tipo_venda_ret_id,
        pd_correios: item.pd_correios,
        vendedor_1: item.vendedor_1,
        status_ped: item.status_ped,
        pago: item.pago,
        taxa_entrega: item.taxa_entrega,
        taxa_wirecard: item.taxa_wirecard,
        inserted_at: item.inserted_at,
        updated_at: item.updated_at,
        items:
          render_many(item.items, TecnovixWeb.ItensDosPedidosDeVendaView, "itens_pedidos.json",
            as: :item
          )
      },
      success: true
    }
  end

  def render("pedidos_protheus.json", %{item: item}) when is_list(item) do
    render_many(item, __MODULE__, "pedido.json", as: :item)
  end

  multi_parser("pedidos.json", [:filial, :cliente, :cliente_id])

  def render("pedido.json", %{item: items}) when is_list(items) do
    render_many(items, __MODULE__, "pedido.json", as: :item)
  end

  def render("pedido.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
