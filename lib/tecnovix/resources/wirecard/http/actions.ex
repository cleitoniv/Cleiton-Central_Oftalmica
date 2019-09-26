defmodule Tecnovix.Resource.Wirecard.Actions do

  alias Tecnovix.Resource.Wirecard.{Account, Order, CreditCard, Payment, Cliente}
  alias Tecnovix.Resource.Wirecard.SDK

  @doc """
  Cria uma conta na Wirecard baseada nos parametros passados
  """
  def create_account(params) do
    %Account{}
    |> Account.changeset(params)
    |> SDK.create(:accounts)
  end

  @doc """
  Cria uma conta de cliente na Wirecard
  """
  def create_cliente(params) do
    %Cliente{}
    |> Cliente.changeset(params)
    |> SDK.create(:customers)
  end

  @doc """
  Cria uma ordem de compra na wirecard 
  """
  def create_order(order_params) do
    %Order{}
    |> Order.changeset(order_params)
    |> SDK.create(:orders)
  end

  @doc """
  Cria um cartão de credito na Wirecard com o cliente id.
  """
  def create_credit_card(params, cliente_id) do
    %CreditCard{}
    |> CreditCard.changeset(params)
    |> SDK.create(cliente_id, :credit_card)
  end

  @doc """
  Cria um pagamento na wirecard baseado no order id.
  """
  def create_payment(params, order_id) do
    %Payment{}
    |> Payment.changeset(params)
    |> SDK.create(order_id, :payment)
  end

  @doc """
  Realiza consultas na Wirecard baseado no type.
  """
  def get(id, type), do: SDK.get(id, type)

  @doc false
  def delete(id, :credit_card), do: SDK.delete(id, :credit_card)
end
