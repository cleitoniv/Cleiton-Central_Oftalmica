defmodule TecnovixWeb.ContasAReceberController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContasAReceberModel
  alias Tecnovix.ContasAReceberModel

  def insert_or_update(conn, params) do
    with {:ok, contas} <- ContasAReceberModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: contas})
    end
  end
end
