defmodule TecnovixWeb.CartaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard

  action_fallback Tecnovix.Resources.Fallback

  def create_order(conn, %{"items" => items}) do
    {:ok, cliente} = conn.private.auth

    with order_params <- CartaoModel.order_params(cliente, items),
         wirecard_order <- __MODULE__.wirecard_order(order_params),
         {:ok, %{status_code: 201} = order} <- Wirecard.create_order(wirecard_order) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true, data: Jason.decode!(order.body)}))
    else
      _ ->
        {:error, :order_not_created}
    end
  end

  def create_payment(conn, %{"cartao" => id_cartao, "order_id" => order_id}) do
    with {:ok, cartao_cliente} <- CartaoModel.get_cartao_cliente(id_cartao),
         payment_params <- CartaoModel.payment_params(cartao_cliente),
         payment <- __MODULE__.wirecard_payment(payment_params),
         {:ok, %{status_code: 201} = payment} <- Wirecard.create_payment(payment, order_id) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{sucess: true, data: Jason.decode!(payment.body)}))
    else
      _ ->
        {:error, :payment_not_created}
    end
  end

  def wirecard_order(params) do
    %{
      "ownId" => params["ownId"],
      "amount" => %{
        "currency" => "BRL",
        "subtotals" => %{
          "shipping" => 1000
        }
      },
      "items" => params["items"],
      "customer" => %{
        "ownId" => params["customers"]["ownId"],
        "fullname" => params["customers"]["fullname"],
        "email" => params["customers"]["email"],
        "birthDate" => params["customers"]["birthDate"],
        "taxDocument" => params["customers"]["taxDocument"],
        "phone" => params["customers"]["phone"],
        "shippingAddress" => params["customers"]["shippingAddress"]
      }
    }
  end

  def wirecard_payment(params) do
    %{
      "installmentCount" => params["installmentCount"],
      "statementDescriptor" => params["statementDescriptor"],
      "fundingInstrument" => params["fundingInstrument"]
    }
  end
end
