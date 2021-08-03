defmodule TecnovixWeb.NotificacoesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.NotificacoesClienteModel
  alias Tecnovix.NotificacoesClienteModel
  alias Tecnovix.UsuariosClienteSchema

  def verify_auth({:ok, cliente}) do
    case cliente do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(cliente, :cliente)
        {:ok, user.cliente}

      cliente ->
        {:ok, cliente}
    end
  end

  def read_notification(conn, %{"id" => id}) do
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, _} <- NotificacoesClienteModel.read_notification(id, cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end
end
