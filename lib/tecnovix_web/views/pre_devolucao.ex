defmodule TecnovixWeb.PreDevolucaoView do
  use Tecnovix.Resource.View, model: Tecnovix.PreDevolucaoModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      filial: item.filial,
      cod_pre_dev: item.cod_pre_dev,
      tipo_pre_dev: item.tipo_pre_dev,
      inclusao: item.inclusao,
      cliente: item.cliente,
      loja: item.loja,
      status: item.status
    }
  end

  multi_parser("devolucao.json", [:filial, :cliente_id])
end
