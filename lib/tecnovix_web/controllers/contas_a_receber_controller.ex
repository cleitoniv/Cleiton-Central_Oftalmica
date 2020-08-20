defmodule TecnovixWeb.ContasAReceberController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContasAReceberModel
  alias Tecnovix.ContasAReceberModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, contas} <- ContasAReceberModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("contas.json", %{item: contas})
    end
  end
end
