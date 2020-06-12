defmodule TecnovixWeb.VendedoresController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.VendedoresModel
  alias Tecnovix.VendedoresModel

  def insert_or_update(conn, params) do
    with {:ok, vendedor} <- VendedoresModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: vendedor})
    end
  end
end
