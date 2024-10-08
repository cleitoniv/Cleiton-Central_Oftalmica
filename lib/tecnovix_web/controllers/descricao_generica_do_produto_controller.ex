defmodule TecnovixWeb.DescricaoGenericaDoProdutoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.DescricaoGenericaDoProdutoModel
  alias Tecnovix.DescricaoGenericaDoProdutoModel, as: DescricaoModel

  action_fallback Tecnovix.Resources.Fallback

  def insert_or_update(conn, params) do
    with {:ok, descricao} <- DescricaoModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("descricao.json", %{item: descricao})
    else
      _ -> {:error, :not_created}
    end
  end

  def verify_graus(conn, params) do
    with {:ok, boolean} <- DescricaoModel.verify_eyes(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: boolean}))
    else
      _ -> {:error, :not_found}
    end
  end

  def verify_graus_olhos_diferentes(conn, %{
        "param" => %{"data" => data} = params
      }) do
    with {:ok, boolean} <- DescricaoModel.verify_eyes(data) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: boolean}))
    else
      {:error, erros} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{success: false, data: %{errors: %{produto: erros}}}))
    end
  end
end
