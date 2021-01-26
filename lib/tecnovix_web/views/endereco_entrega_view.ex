defmodule Tecnovix.EnderecoEntregaView do
  use Tecnovix.Resource.View, model: Tecnovix.EnderecoEntregaModel

  def build(%{item: item}) do
    %{
      id: item.id,
      numero_entrega: item.numero_entrega,
      cep_entrega: item.cep_entrega,
      complemento_entrega: item.complemento_entrega,
      bairro_entrega: item.bairro_entrega,
      cidade_entrega: item.cidade_entrega,
      endereco_entrega: item.endereco_entrega,
      estado_entrega: item.estado_entrega,
      cliente_id: item.cliente_id
    }
  end
end
