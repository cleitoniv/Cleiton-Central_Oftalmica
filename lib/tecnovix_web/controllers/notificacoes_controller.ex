defmodule TecnovixWeb.NotificacoesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.NotificacoesClienteModel
  alias Tecnovix.NotificacoesClienteModel

  def read_notification(conn, %{"read" => read}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, _} <- NotificacoesClienteModel.read_notification(cliente, read) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{succes: true}))
    end
  end
end
