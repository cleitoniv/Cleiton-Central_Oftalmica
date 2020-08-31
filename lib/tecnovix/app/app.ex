defmodule Tecnovix.App.Screens do
  @callback get_product_grid(cliente :: term, filtro :: term) :: {:ok, term}
  @callback get_credits(cliente :: term) :: {:ok, term}
  @callback get_notifications_open(cliente :: term) :: {:ok, term}
  @callback get_offers(cliente :: term) :: {:ok, term}
  @callback get_products_credits(cliente :: term) :: {:ok, term}
  @callback get_order(cliente :: term, filtro :: term) :: {:ok, term}
  @callback get_products_cart(cliente :: term) :: {:ok, term}
  @callback get_info_product(cliente :: term, id :: term) :: {:ok, term}
  @callback get_product(cliente :: term, id :: term) :: {:ok, term}
  @callback get_detail_order(cliente :: term) :: {:ok, term}
  @callback get_cards(cliente :: term) :: {:ok, term}
  @callback get_payments(cliente :: term) :: {:ok, term}
  
  def stub() do
    case Mix.env() do
      :prod -> Tecnovix.App.ScreensProd
      :test -> Tecnovix.App.ScreensTest
      :dev -> Tecnovix.App.ScreensTest
    end
  end
end
