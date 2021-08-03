defmodule TecnovixWeb.DescricaoGenericaDoProdutoView do
  use Tecnovix.Resource.View, model: Tecnovix.DescricaoGenericaDoProdutoModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      grupo: item.grupo,
      codigo: item.codigo,
      descricao: item.descricao,
      esferico: item.esferico,
      cilindrico: item.cilindrico,
      eixo: item.eixo,
      cor: item.cor,
      diametro: item.diametro,
      curva_base: item.curva_base,
      adic_padrao: item.adic_padrao,
      adicao: item.adicao,
      raio_curva: item.raio_curva,
      link_am_app: item.link_am_app,
      blo_de_tela: item.blo_de_tela
    }
  end

  def render("descricao.json", %{item: items}) when is_list(items) do
    render_many(items, __MODULE__, "descricao.json", as: :item)
  end

  def render("descricao.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
