defmodule TecnovixWeb.ItensPreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ItensPreDevolucaoModel
  alias Tecnovix.ItensPreDevolucaoModel

  def insert_or_update(conn, params) do
    with {:ok, itens} <- ItensPreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: itens})
    end
  end
end
