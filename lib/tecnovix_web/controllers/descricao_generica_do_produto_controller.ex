defmodule TecnovixWeb.DescricaoGenericaDoProdutoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.DescricaoGenericaDoProdutoModel
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  def insert_or_update(conn, params) do
    with {:ok, _descricao} <- DescricaoModel.insert_or_update(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true}))
    end
  end
end
