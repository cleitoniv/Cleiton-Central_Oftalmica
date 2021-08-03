defmodule TecnovixWeb.CreditoFinanceiroView do
  use Tecnovix.Resource.View, model: Tecnovix.CreditoFinanceiroModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      id: item.id,
      cliente_id: item.cliente_id,
      valor: item.valor,
      desconto: item.desconto,
      prestacoes: item.prestacoes,
      tipo_pagamento: item.tipo_pagamento,
      saldo: item.saldo,
      inserted_at: item.inserted_at,
      status: item.status
    }
  end

  def render("creditos.json", %{item: items}) when is_list(items) do
    render_many(items, __MODULE__, "show.json", as: :item)
  end
end
