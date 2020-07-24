defmodule TecnovixWeb.LogsClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.LogsClienteModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  def create(conn, %{"param" => params}) do
    with {:ok, user_logs} <- Tecnovix.LogsClienteModel.create(params) do
      {:ok, user} = conn.private.auth
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true, data: %{
        nome: user.nome,
        email: user.email,
        ddd: user.ddd,
        telefone: user.telefone,
        sit_app: user.sit_app,
        bloqueado: user.bloqueado
        }}))
      else
        _ ->
        {:error, :invalid_parameter}
    end
  end

  def create_logs(conn, %{"param" => params}) do
    case conn.private.auth do
      {:ok, %ClientesSchema{} = user} ->
        params = Map.put(params, "cliente_id", user.id)
        __MODULE__.create(conn, %{"param" => params})
      {:ok, %UsuariosClienteSchema{} = client_user} ->
        params = Map.put(params, "cliente_id", client_user.cliente_id)
        params = Map.put(params, "usuario_cliente_id", client_user.id)
        __MODULE__.create(conn, %{"param" => params})
        _ ->
        {:error, :invalid_parameter}
    end
  end
end
