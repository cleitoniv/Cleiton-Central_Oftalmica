defmodule TecnovixWeb.PreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PreDevolucaoModel
  alias Tecnovix.PreDevolucaoModel

  def insert_or_update(conn, params) do
    with {:ok, itens} <- PreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: itens})
    end
  end
end
