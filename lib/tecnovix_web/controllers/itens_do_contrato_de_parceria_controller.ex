defmodule TecnovixWeb.ItensDoContratoDeParceriaController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ItensDoContratoDeParceriaModel
  alias Tecnovix.ItensDoContratoDeParceriaModel, as: ItensDoContratoDeParceriaModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, _itens_contrato} <- ItensDoContratoDeParceriaModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end
end
