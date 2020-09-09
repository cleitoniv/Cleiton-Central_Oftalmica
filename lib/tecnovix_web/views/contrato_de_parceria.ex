defmodule TecnovixWeb.ContratoDeParceriaView do
  use Tecnovix.Resource.View, model: Tecnovix.ContratoDeParceriaModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.client_id,
      filial: item.filial,
      contrato_n: item.contrato_n,
      docto_orig: item.docto_orig,
      emissao: item.emissao,
      cliente: item.cliente,
      loja: item.loja,
      items:
        render_many(item.items, TecnovixWeb.ItensDoContratoDeParceriaView, "itens_contrato.json",
          as: :item
        )
    }
  end

  multi_parser("contrato.json", [:contrato_n, :loja])

  def render("contrato.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
