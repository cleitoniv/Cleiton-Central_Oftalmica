defmodule Tecnovix.Resource.Wirecard.HttpTest do
  use ExUnit.Case
  alias Tecnovix.TestHelper

  test "Create account", _context do

    {:ok, resp} = TestHelper.create_account()
    assert resp.status_code == 201
  end

  test "Create Cliente", _context do
    {:ok, resp} = TestHelper.create_cliente()
    assert resp.status_code == 201
  end

  test "Create Orders", _context do
    {:ok, cliente} = TestHelper.create_cliente()
    {:ok, resp} = TestHelper.create_order(cliente)
    assert resp.status_code == 201
  end

  test "Create Credit Card", _context do
    {:ok, cliente} = TestHelper.create_cliente()
    cliente = Jason.decode!(cliente.body)
    {:ok, credit_card} = TestHelper.create_credit_card(cliente["id"])
    assert credit_card.status_code == 201
  end

  # test "Create Payment", _context do
  #   {:ok, cliente} = TestHelper.create_cliente()
  #   {:ok, order} = TestHelper.create_order(cliente)
  #   order = Jason.decode!(order.body)
  #   {:ok, payment} = TestHelper.create_payment(order["id"])
  #   IO.inspect payment
  #   assert payment.status_code == 201
  # end
end
