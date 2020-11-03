defmodule TecnovixWeb.ContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContratoDeParceriaModel
  alias Tecnovix.{ContratoDeParceriaModel, UsuariosClienteSchema, NotificacoesClienteModel}

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, contrato} <- ContratoDeParceriaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    end
  end

  def verify_auth({:ok, cliente}) do
    case cliente do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(cliente, :cliente)
        {:ok, user.cliente}

      v ->
        {:ok, v}
    end
  end

  def create(conn, %{"items" => items, "id_cartao" => id_cartao, "ccv" => ccv}) do
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, items_order} <- ContratoDeParceriaModel.items_order(items),
         {:ok, order} <- ContratoDeParceriaModel.order(cliente, items_order),
         {:ok, _payment} <- ContratoDeParceriaModel.payment(id_cartao, order, ccv),
         {:ok, contrato} <- ContratoDeParceriaModel.create_contrato(cliente, items, order),
         {:ok, _notifications} <-
           NotificacoesClienteModel.credit_product_adquired(contrato, cliente) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    else
      _ -> {:error, :order_not_created}
    end
  end
end
