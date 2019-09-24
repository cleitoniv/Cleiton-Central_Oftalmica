defmodule Tecnovix.Resources.SchemaTest do
  use ExUnit.Case

  alias Tecnovix.Resource.Wirecard.Account
  alias Tecnovix.Resource.Wirecard.Cliente
  alias Tecnovix.Resource.Wirecard.CreditCard
  alias Tecnovix.Resource.Wirecard.Order
  alias Tecnovix.Resource.Wirecard.Order
  alias Tecnovix.Resource.Wirecard.Payment
  alias Tecnovix.TestHelper

  test "create account", _context do
    params = TestHelper.parse_json("account.json")
    changeset = Account.changeset(%Account{}, params)
    assert changeset.valid?
  end

  test "create cliente", _context do
    params = TestHelper.parse_json("cliente.json")
    uuid = Ecto.UUID.generate()
    changeset = Cliente.changeset(%Cliente{ownId: uuid}, params)
    assert changeset.valid?
  end

  # test "create credit card", _context do
  #   params = TestHelper.parse_json("credit_card.json")
  #   changeset = CreditCard.changeset(%CreditCard{}, params)
  #   assert changeset.valid?
  # end

  test "create order", _context do
    params = TestHelper.parse_json("order.json")
    changeset = Order.changeset(%Order{}, params)
    assert changeset.valid?
  end

  test "create payment", _context do
    params = TestHelper.parse_json("payment.json")
    changeset = Payment.changeset(%Payment{}, params)
    IO.inspect changeset
    assert changeset.valid?
  end
end
