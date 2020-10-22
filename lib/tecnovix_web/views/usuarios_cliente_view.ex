defmodule TecnovixWeb.UsuariosClienteView do
  use Tecnovix.Resource.View, model: Tecnovix.UsuariosClienteModel

  def build(%{item: item}) do
    %{
      cliente_id: item.cliente_id,
      id: item.id,
      nome: item.nome,
      email: item.email,
      cargo: item.cargo,
      status: item.status,
      password: item.password
    }
  end

  def render("users.json", %{item: item}) do
    %{
      success: true,
      data: render_many(item, __MODULE__, "show.json", as: :item)
    }
  end
end
