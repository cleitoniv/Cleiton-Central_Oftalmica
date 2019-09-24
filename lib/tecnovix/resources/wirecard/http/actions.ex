defmodule Tecnovix.Resource.Wirecard.Actions do

  alias Tecnovix.Resource.Wirecard.{Account, Order, CreditCard, Payment, Cliente}
  alias Tecnovix.Resource.Wirecard.SDK

  def create_account(params) do
    %Account{}
    |> Account.changeset(params)
    |> SDK.create(:accounts)
  end

  def create_cliente(params) do
    %Cliente{}
    |> Cliente.changeset(params)
    |> SDK.create(:customers)
  end

  def create_order(order_params) do
    %Order{}
    |> Order.changeset(order_params)
    |> SDK.create(:orders)
  end

  def create_credit_card(params, cliente_id) do
    %CreditCard{}
    |> CreditCard.changeset(params)
    |> SDK.create(cliente_id, :credit_card)
  end

  def create_payment(params, order_id) do
    %Payment{}
    |> Payment.changeset(params)
    |> SDK.create(order_id, :payment)
  end

end
