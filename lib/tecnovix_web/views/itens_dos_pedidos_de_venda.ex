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
      status: item.status,
      produto: item.produto,
      quantidade: item.quantidade,
      prc_unitario: item.prc_unitario,
      valor_test: item.valor_test,
      olho: item.olho,
      paciente: item.paciente,
      num_pac: item.num_pac,
      dt_nas_pac: item.dt_nas_pac,
      virtotal: item.virtotal,
      esferico: item.esferico,
      cilindrico: item.cilindrico,
      valor_credito_finan: item.valor_credito_finan,
      valor_credito_prod: item.valor_credito_prod,
      eixo: item.eixo,
      cor: item.cor,
      adic_padrao: item.adic_padrao,
      adicao: item.adicao,
      nota_fiscal: item.nota_fiscal,
      serie_nf: item.serie_nf,
      duracao: item.duracao,
      grupo: item.grupo,
      percentage_test: item.percentage_test,
      num_pedido: item.num_pedido,
      inserted_at: item.inserted_at,
      produto_teste: item.produto_teste
    }
  end

  def render("itens_pedidos.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
