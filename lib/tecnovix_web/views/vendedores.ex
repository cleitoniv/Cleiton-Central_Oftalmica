defmodule TecnovixWeb.VendedoresView do
  use Tecnovix.Resource.View, model: Tecnovix.VendedoresModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      uid: item.uid,
      codigo: item.codigo,
      nome: item.nome,
      sit_app: item.sit_app,
      cnpj_cpf: item.cnpj_cpf,
      email: item.email,
      regiao: item.regiao,
      ddd: item.ddd,
      telefone: item.telefone,
      status: item.status
    }
  end

  multi_parser("vendedores.json", [:nome])

  def render("vendedores.json", %{item: item}) do
    __MODULE__.build(%{item: item})
  end
end
