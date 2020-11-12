defmodule TecnovixWeb.ItensDosPedidosDeVendaView do
  use Tecnovix.Resource.View, model: Tecnovix.ItensDosPedidosDeVendaModel

  def build(%{item: item}) do
    %{
      id: item.id,
      pedido_de_venda_id: item.pedido_de_venda_id,
      descricao_generica_do_produto_id: item.descricao_generica_do_produto_id,
      filial: item.filial,
      nocontrato: item.nocontrato,
      codigo: item.codigo,
      tests: item.tests,
      operation: item.operation,
      tipo_venda: item.tipo_venda,
      produto: item.produto,
      quantidade: item.quantidade,
      prc_unitario: item.prc_unitario,
      olho: item.olho,
      paciente: item.paciente,
      num_pac: item.num_pac,
      dt_nas_pac: item.dt_nas_pac,
      virtotal: item.virtotal,
      esferico: item.esferico,
      cilindrico: item.cilindrico,
      eixo: item.eixo,
      cor: item.cor,
      adic_padrao: item.adic_padrao,
      adicao: item.adicao,
      nota_fiscal: item.nota_fiscal,
      serie_nf: item.serie_nf,
      duracao: item.duracao,
      grupo: item.grupo,
      num_pedido: item.num_pedido,
      inserted_at: item.inserted_at,
      update_at: item.updated_at
    }
  end

  def render("itens_pedidos.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
