defmodule TecnovixWeb.ItensPreDevolucaoView do
  use Tecnovix.Resource.View, model: Tecnovix.ItensPreDevolucaoModel

  def build(%{item: item}) do
    %{
      pre_devolucao_id: item.pre_devolucao_id,
      descricao_generica_do_produto_id: item.descricao_generica_do_produto_id,
      filial: item.filial,
      cod_pre_dev: item.cod_pre_dev,
      item: item.item,
      filial_orig: item.filial_orig,
      num_de_serie: item.num_de_serie,
      produto: item.produto,
      quant: item.quant,
      prod_subs: item.prod_subs,
      descricao: item.descricao,
      doc_devol: item.doc_devol,
      serie: item.serie,
      doc_saida: item.doc_saida,
      serie_saida: item.serie_saida,
      item_doc: item.item_doc,
      contrato: item.contrato,
      tipo: item.tipo
    }
  end

  def render("itens_devolucao.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
