defmodule TecnovixWeb.CartaoCreditoClienteController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel

  action_fallback Tecnovix.Resources.Fallback

  def create(conn, %{"param" => params}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, _result} <- CartaoModel.get_cc(%{"cliente_id" => cliente.id}),
         {:ok, cartao} <- CartaoModel.primeiro_cartao(params, cliente.id),
         {:ok, detail_card} <- CartaoModel.detail_card(cartao, cliente),
         {:ok, card} <- CartaoModel.create(detail_card) do

      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("show.json", %{item: card})
    else
      _ ->
        {:error, :card_not_created}
    end
  end
end
