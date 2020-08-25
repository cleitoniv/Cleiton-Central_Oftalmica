defmodule TecnovixWeb.NotificacoesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.NotificacoesClienteModel
  alias Tecnovix.NotificacoesClienteModel

  def lido(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, notificacao} <- NotificacoesClienteModel.lido(cliente.id, params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: notificacao})
    end
  end
end
