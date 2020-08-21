defmodule Tecnovix.Resource.Wirecard.HttpTest do
  use ExUnit.Case
  alias Tecnovix.TestHelper
  alias Tecnovix.Resource.Wirecard.Actions

  test "Create account", _context do
    {:ok, resp} = TestHelper.create_account()
    assert resp.status_code == 201
  end

  test "Create and Get Cliente", _context do
    {:ok, create_cliente} = TestHelper.create_cliente()
    cliente = Jason.decode!(create_cliente.body)
    {:ok, cliente} = Actions.get(cliente["id"], :customers)
    assert cliente.status_code == 200
    assert create_cliente.status_code == 201
  end

  test "Create and Get Orders", _context do
    {:ok, cliente} = TestHelper.create_cliente()
    {:ok, create_order} = TestHelper.create_order(cliente)
    order = Jason.decode!(create_order.body)
    {:ok, order} = Actions.get(order["id"], :orders)
    IO.inspect Jason.decode!(order.body)["items"]
    assert order.status_code == 200
    assert create_order.status_code == 201
  end

  test "Create and Delete Credit Card", _context do
    {:ok, cliente} = TestHelper.create_cliente()
    cliente = Jason.decode!(cliente.body)
    {:ok, create_credit_card} = TestHelper.create_credit_card(cliente["id"])
    assert create_credit_card.status_code == 201
  end

  test "Create and Get Payment", _context do
    {:ok, cliente} = TestHelper.create_cliente()
    {:ok, order} = TestHelper.create_order(cliente)
    order = Jason.decode!(order.body)
    {:ok, create_payment} = TestHelper.create_payment(order["id"])
    payment = Jason.decode!(create_payment.body)
    {:ok, get_payment} = Actions.get(payment["id"], :payments)
    assert get_payment.status_code == 200
    assert create_payment.status_code == 201
  end
end
