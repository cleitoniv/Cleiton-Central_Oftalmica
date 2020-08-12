defmodule TecnovixWeb.LogsClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.LogsClienteModel
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    with {:ok, user_logs} <- Tecnovix.LogsClienteModel.create(params) do
      conn
      |> put_resp_content_type("application/json")
      |> put_view(TecnovixWeb.LogsClienteView)
      |> render("show.json", %{item: user_logs})
    else
      _ ->
        {:error, :invalid_parameter}
    end
  end

  def create_logs(conn, %{"param" => params}) do
    case conn.private.auth do
      # logs para o cliente
      {:ok, %ClientesSchema{} = user} ->
        params = Map.put(params, "cliente_id", user.id)
        __MODULE__.create(conn, %{"param" => params})

      # logs para o usuario_cliente
      {:ok, %UsuariosClienteSchema{} = client_user} ->
        params = Map.put(params, "cliente_id", client_user.cliente_id)
        params = Map.put(params, "usuario_cliente_id", client_user.id)
        __MODULE__.create(conn, %{"param" => params})

      _ ->
        {:error, :invalid_parameter}
    end
  end
end
