defmodule TecnovixWeb.UsuariosClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.UsuariosClienteModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      uid: item.uid,
      nome: item.nome,
      email: item.email,
      cargo: item.cargo,
      status: item.status
    }
  end
end
