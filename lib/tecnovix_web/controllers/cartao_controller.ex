defmodule TecnovixWeb.CartaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard

  def create_order(conn, %{"items" => items}) do
    IO.inspect {:ok, cliente} = conn.private.auth

    with order_params <- CartaoModel.order_params(cliente, items),
          wirecard_order <- __MODULE__.wirecard_order(order_params),
         {:ok, %{status_code: 201} = _order} <- Wirecard.create_order(wirecard_order) do

           conn
           |> put_resp_content_type("application/json")
           |> send_resp(200, Jason.encode!(%{sucess: true}))
    else
      _ ->
        {:error, :not_created}
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
      },
      "receivers" => [
        %{
          "type" => "PRIMARY",
          "feePayor" => false,
          "moipAccount" => %{
            "id" => "MPA-E3C8493A06AE"
          },
          "amount" => %{
            "fixed" => params["fixed"]
          }
        }
      ]
    }
  end
end
