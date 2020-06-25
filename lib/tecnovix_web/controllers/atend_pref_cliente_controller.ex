defmodule TecnovixWeb.AtendPrefClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.AtendPrefClienteModel
  alias Tecnovix.AtendPrefClienteModel

  def insert_or_update(conn, params) do
    with {:ok, cliente} <- AtendPrefClienteModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: cliente})
    end
  end
end
