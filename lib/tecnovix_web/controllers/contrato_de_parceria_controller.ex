defmodule TecnovixWeb.ContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContratoDeParceriaModel
  alias Tecnovix.ContratoDeParceriaModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, contrato} <- ContratoDeParceriaModel.insert_or_update(params) do
      IO.inspect contrato
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contrato.json", %{item: contrato})
    end
  end
end
