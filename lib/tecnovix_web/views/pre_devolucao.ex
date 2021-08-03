defmodule TecnovixWeb.PreDevolucaoView do
  use Tecnovix.Resource.View, model: Tecnovix.PreDevolucaoModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      id: item.id,
      client_id: item.client_id,
      filial: item.filial,
      cod_pre_dev: item.cod_pre_dev,
      tipo_pre_dev: item.tipo_pre_dev,
      inclusao: item.inclusao,
      cliente: item.cliente,
      loja: item.loja,
      status: item.status,
      inserted_at: item.inserted_at,
      items:
        render_many(item.items, TecnovixWeb.ItensPreDevolucaoView, "itens_devolucao.json",
          as: :item
        )
    }
  end

  multi_parser("devolucao.json", [:filial, :cliente_id])

  def render("devolucoes.json", %{item: items}) do
    render_many(items, __MODULE__, "devolucao.json", as: :item)
  end

  def render("devolucao.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
