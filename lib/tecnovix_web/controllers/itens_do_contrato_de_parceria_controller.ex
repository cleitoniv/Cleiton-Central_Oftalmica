defmodule TecnovixWeb.ItensDoContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ItensDoContratoDeParceriaModel
  alias Tecnovix.ItensDoContratoDeParceriaModel, as: ItensDoContratoDeParceriaModel

  def insert_or_update(conn, params) do
    with {:ok, itens_contrato} <- ItensDoContratoDeParceriaModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: itens_contrato})
    end
  end
end
