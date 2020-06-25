defmodule TecnovixWeb.CartaoCreditoClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.CartaoCreditoClienteModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      nome_titular: item.nome_titular,
      cpf_titular: item.cpf_titular,
      telefone_titular: item.telefone_titular,
      data_nascimento_titular: item.data_nascimento_titular,
      primeiros_6_digitos: item.primeiros_6_digitos,
      ultimos_4_digitos: item.ultimos_4_digitos,
      mes_validade: item.mes_validade,
      ano_validade: item.ano_valdiade,
      bandeira: item.bandeira,
      status: item.status,
      wirecard_cartao_credito_id: item.wirecard_cartao_credito_id,
      cep_endereco_cobranca: item.cep_endereco_cobranca,
      logradouro_endereco_cobranca: item.logradouro_endereco_cobranca,
      numero_endereco_cobranca: item.numero_endereco_cobranca,
      complemento_endereco_cobranca: item.complemento_endereco_cobranca,
      bairro_endereco_cobranca: item.bairro_endereco_cobranca,
      cidade_endereco_cobranca: item.cidade_endereco_cobranca,
      estado_endereco_cobranca: item.estado_endereco_cobranca
    }
  end
end
