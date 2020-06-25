defmodule TecnovixWeb.ItensDoContratoDeParceriaView do
  use Tecnovix.Resource.View, model: Tecnovix.ItensDoContratoParceriaModel

  def build(%{item: item}) do
    %{
      contrato_de_parceria_id: item.contrato_de_parceria_id,
      descricao_generica_do_produto_id: item.descricao_generica_do_produto_id,
      filial: item.filial,
      produto: item.produto,
      preco_venda: item.preco_venda,
      total: item.total,
      cliente: item.cliente,
      loja: item.loja
    }
  end
end
