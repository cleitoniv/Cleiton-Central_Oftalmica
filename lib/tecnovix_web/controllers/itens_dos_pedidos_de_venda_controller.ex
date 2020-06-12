defmodule TecnovixWeb.ItensDosPedidosDeVendaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ItensDosPedidosDeVendaModel
  alias Tecnovix.ItensDosPedidosDeVendaModel

  def insert_or_update(conn, params) do
    with {:ok, itens} <- ItensDosPedidosDeVendaModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: itens})
    end
  end
end
