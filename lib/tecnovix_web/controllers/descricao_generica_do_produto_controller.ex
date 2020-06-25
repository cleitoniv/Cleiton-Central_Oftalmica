defmodule TecnovixWeb.DescricaoGenericaDoProdutoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.DescricaoGenericaDoProdutoModel
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  def insert_or_update(conn, params) do
    with {:ok, descricao} <- DescricaoModel.insert_or_update(params) do
      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> render("item.json", %{item: descricao})
    end
  end
end
