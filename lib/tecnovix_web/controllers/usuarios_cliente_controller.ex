defmodule TecnovixWeb.UsuariosClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.UsuariosClienteModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.Auth.Firebase
  alias Tecnovix.UsuariosClienteModel
  action_fallback Tecnovix.Resources.Fallback

  def update_users(conn, %{"id" => id, "param" => params}) do
    {:ok, cliente} = conn.private.auth
    with {:ok, user} <- UsuariosClienteModel.search_user(id),
         user.cliente_id == cliente.id,
         {:ok, user} <- UsuariosClienteModel.update(user, params) do
            conn
            |> put_status(:ok)
            |> put_resp_content_type("application/json")
            |> send_resp(200, Jason.encode!(%{sucess: true, data: %{
            nome: user.nome,
            email: user.email,
            cargo: user.cargo,
            status: user.status
            }}))
      else
        _ -> {:error, :invalid_parameter}
    end
  end

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
