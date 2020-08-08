defmodule TecnovixWeb.ContasAReceberController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ContasAReceberModel
  alias Tecnovix.ContasAReceberModel

  def insert_or_update(conn, params) do
    with {:ok, _contas} <- ContasAReceberModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end
end
