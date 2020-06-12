defmodule TecnovixWeb.VendedoresView do
  use Tecnovix.Resource.View, model: Tecnovix.VendedoresModel

  def build(%{item: item}) do
    %{
      uid: item.uid,
      codigo: item.codigo,
      nome: item.nome,
      sit_app: item.sit_app,
      cnpj_cpf: item.cnpj_cpf,
      email: item.email,
      regiao: item.regiao,
      celular: item.celular,
      status: item.status,
      moip_account_id: item.moip_account_id,
      moip_acess_token: item.moip_acess_token
    }
  end
end
