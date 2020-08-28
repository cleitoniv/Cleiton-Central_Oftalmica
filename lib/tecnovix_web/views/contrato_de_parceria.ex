defmodule TecnovixWeb.ContratoDeParceriaView do
  use Tecnovix.Resource.View, model: Tecnovix.ContratoDeParceriaModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      filial: item.filial,
      contrato_n: item.contrato_n,
      docto_orig: item.docto_orig,
      emissao: item.emissao,
      cliente: item.cliente,
      loja: item.loja
    }
  end

  multi_parser("contrato.json", [:contrato_n, :loja])

  def render("contrato.json", %{item: item}) do
    %{
      id: item.id
    }
  end
end
