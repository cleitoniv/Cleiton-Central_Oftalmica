defmodule TecnovixWeb.CartaoCreditoClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    with {:ok, card} <- CartaoModel.create(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: card})
    else
      _ -> {:error, :not_created}
    end
  end
end
