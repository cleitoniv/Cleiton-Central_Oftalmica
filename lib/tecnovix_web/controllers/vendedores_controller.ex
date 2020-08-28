defmodule TecnovixWeb.VendedoresController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.VendedoresModel
  alias Tecnovix.VendedoresModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, vendedor} <- VendedoresModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("vendedores.json", %{item: vendedor})
    end
  end
end
