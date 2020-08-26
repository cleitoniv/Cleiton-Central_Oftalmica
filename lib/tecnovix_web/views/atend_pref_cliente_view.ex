defmodule TecnovixWeb.AtendPrefClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.AtendPrefClienteModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      cod_cliente: item.cod_cliente,
      loja_cliente: item.loja_cliente,
      seg_manha: item.seg_manha,
      seg_tarde: item.seg_tarde,
      ter_manha: item.ter_manha,
      ter_tarde: item.ter_tarde,
      qua_manha: item.qua_manha,
      qua_tarde: item.qua_tarde,
      qui_manha: item.qui_manha,
      qui_tarde: item.qui_tarde,
      sex_manha: item.sex_manha,
      sex_tarde: item.sex_tarde,
      sab_manha: item.sab_manha,
      sab_tarde: item.sab_tarde
    }
  end

  multi_parser("atends.json", [:cliente_id, :cod_cliente, :loja_cliente])

  def render("atends.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
