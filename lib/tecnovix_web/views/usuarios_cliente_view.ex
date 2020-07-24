defmodule TecnovixWeb.UsuariosClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.UsuariosClienteModel

  def build(%{item: item}) do
    %{
      id: item.id,
      cliente_id: item.cliente_id,
      uid: item.uid,
      nome: item.nome,
      email: item.email,
      cargo: item.cargo,
      status: item.status,
      senha_enviada: item.senha_enviada
    }
  end
end
