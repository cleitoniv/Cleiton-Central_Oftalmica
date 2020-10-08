defmodule TecnovixWeb.PreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PreDevolucaoModel
  alias Tecnovix.{PreDevolucaoModel, NotificacoesClienteModel}

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, devolucao} <- PreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("devolucao.json", %{item: devolucao})
    end
  end

  def create(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, devolucoes} <- PreDevolucaoModel.create(cliente, params),
         {:ok, _notifications} <- NotificacoesClienteModel.solicitation_devolution(devolucoes, cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("devolucoes.json", %{item: devolucoes})
    else
      _ ->
        {:error, :not_created}
    end
  end
end
