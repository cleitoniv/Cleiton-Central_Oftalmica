defmodule Tecnovix.App.Screens do
  @callback get_product_grid(cliente :: term, filtro :: term, term, term) :: {:ok, term, term}
  @callback get_credits(cliente :: term) :: term
  @callback get_notifications(cliente :: term) :: {:ok, term}
  @callback get_offers(cliente :: term) :: {:ok, term}
  @callback get_products_credits(cliente :: term) :: {:ok, term}
  @callback get_info_product(cliente :: term, id :: term) :: {:ok, term}
  @callback get_detail_order(cliente :: term, String.t()) :: {:ok, term}
  @callback get_cards(cliente :: term) :: {:ok, term}
  @callback get_payments(list, list, list, Strin.t()) :: {:ok, term}
  @callback get_mypoints(cliente :: term) :: {:ok, term}
  @callback get_product_serie(cliente :: term, product_serial :: term, term()) :: {:ok, term}
  @callback get_extrato_finan(cliente :: term) :: {:ok, term}
  @callback get_extrato_prod(cliente :: term, term) :: {:ok, term}
  @callback get_and_send_email_dev(email :: term) :: {:ok, term}
  @callback get_dia_remessa(cliente :: term) :: term()
  @callback get_endereco_entrega(cliente :: term) :: {:ok, term}

  def stub() do
    case Mix.env() do
      :prod -> Tecnovix.App.ScreensProd
      :test -> Tecnovix.App.ScreensTest
      :dev -> Tecnovix.App.ScreensTest
    end
  end
end
