defmodule TecnovixWeb.ClientesView do
  use Tecnovix.Resource.View, model: Tecnovix.ClientesModel

  def build(%{item: item}) do
    %{
      id: item.id,
      uid: item.uid,
      codigo: item.codigo,
      loja: item.loja,
      fisica_jurid: item.fisica_jurid,
      cnpj_cpf: item.cnpj_cpf,
      data_nascimento: item.data_nascimento,
      nome: item.nome,
      nome_empresarial: item.nome_empresarial,
      email: item.email,
      endereco: item.endereco,
      numero: item.numero,
      complemento: item.complemento,
      bairro: item.bairro,
      cep: item.cep,
      cdmunicipio: item.cdmunicipio,
      municipio: item.municipio,
      ddd: item.ddd,
      telefone: item.telefone,
      bloqueado: item.bloqueado,
      sit_app: item.sit_app,
      cod_cnae: item.cod_cnae,
      ramo: item.ramo,
      vendedor: item.vendedor,
      crm_medico: item.crm_medico,
      dia_remessa: item.dia_remessa,
      wirecard_cliente_id: item.wirecard_cliente_id,
      fcm_token: item.fcm_token,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
  end
end
