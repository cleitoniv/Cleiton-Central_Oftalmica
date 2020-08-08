defmodule TecnovixWeb.ItensPreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ItensPreDevolucaoModel
  alias Tecnovix.ItensPreDevolucaoModel

  def insert_or_update(conn, params) do
    with {:ok, _itens} <- ItensPreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end
end
