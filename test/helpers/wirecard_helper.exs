defmodule Tecnovix.TestHelper do

  alias Tecnovix.Resource.Wirecard.{Account, Order, CreditCard, Payment, Cliente}
  alias Tecnovix.Resource.Wirecard.SDK
  alias Tecnovix.Resource.Wirecard.Actions
  alias Tecnovix.TestHelper

  def parse_json(path) do
    File.read!("test/resources/wirecard/" <> path)
    |> Jason.decode!()
  end

  def create_account() do
    params = TestHelper.parse_json("account.json")
    Actions.create_account(params)
  end

  def create_cliente() do
    params = TestHelper.parse_json("cliente.json")
    params = %{params | "ownId" => Ecto.UUID.generate()}
    Actions.create_cliente(params)
  end

  def create_order(cliente) do

    cliente = Jason.decode!(cliente.body)

    order_params = TestHelper.parse_json("order.json")
    order_params = update_in(order_params["customer"]["id"], fn _ -> cliente["id"] end)

    Actions.create_order(order_params)
  end

  def create_credit_card(cliente_id) do
    params = TestHelper.parse_json("credit_card.json")

    Actions.create_credit_card(params, cliente_id)
  end

  def create_payment(order_id) do
    params = TestHelper.parse_json("payment.json")

    Actions.create_payment(params, order_id)
  end

end
