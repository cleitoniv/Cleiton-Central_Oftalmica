defmodule TecnovixWeb.UsuariosClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.UsuariosClienteModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.Auth.Firebase
  action_fallback Tecnovix.Resources.Fallback

  def create_user(conn, %{"param" => params}) do
    case conn.private.auth do
      {:ok, %ClientesSchema{} = user} ->
        params = Map.put(params, "cliente_id", user.id)
        __MODULE__.create(conn, %{"param" => params})
      _ ->
      {:error, :invalid_parameter}
    end

  end
end
