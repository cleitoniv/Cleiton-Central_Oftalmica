defmodule TecnovixWeb.ContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContratoDeParceriaModel
  alias Tecnovix.ContratoDeParceriaModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, contrato} <- ContratoDeParceriaModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    end
  end

  def create(conn, %{"items" => items, "id_cartao" => id_cartao}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, items_order} <- ContratoDeParceriaModel.items_order(items),
         {:ok, order} <- ContratoDeParceriaModel.order(cliente, items_order),
         {:ok, payment} <- ContratoDeParceriaModel.payment(id_cartao, order),
         {:ok, contrato} <- ContratoDeParceriaModel.create_contrato(cliente, items, order) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    else
      v ->
        IO.inspect(v)
        {:error, :order_not_created}
    end
  end
end
