defmodule TecnovixWeb.ContasAReceberView do
  use Tecnovix.Resource.View, model: Tecnovix.ContasAReceberModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      filial: item.filial,
      no_titulo: item.no_titulo,
      tipo: item.tipo,
      cliente: item.cliente,
      loja: item.loja,
      dt_emissao: item.dt_emissao,
      vencto_real: item.vencto_real,
      virtitulo: item.virtitulo,
      saldo: item.saldo,
      cod_barras: item.cod_barras
    }
  end

  multi_parser("contas.json", [:cliente, :loja])
end
