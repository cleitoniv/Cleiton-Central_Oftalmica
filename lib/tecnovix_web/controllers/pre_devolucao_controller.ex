defmodule TecnovixWeb.PreDevolucaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.PreDevolucaoModel
  alias Tecnovix.PreDevolucaoModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, _itens} <- PreDevolucaoModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end
end
