defmodule TecnovixWeb.CartaoController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.CartaoDeCreditoModel
  alias Tecnovix.CartaoDeCreditoModel, as: CartaoModel
  alias Tecnovix.Resource.Wirecard.Actions

  def create_cc(conn, params, cliente) do
    wirecard_cliente = __MODULE__.wirecard_cliente(cliente)

    with {:ok, %{status_code: 201} = cliente_param} <- Actions.create_cliente(wirecard_cliente),
         {:ok, cliente} <- __MODULE__.create(params, cliente_param) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, Jason.decode!(%{sucess: true}))
    else
      _ ->
        {:error, :not_created}
    end
  end

  def create(params, cliente) do
    cliente = Jason.decode!(cliente.body)

    params
    |> Map.put("wirecard_cartao_credito_id", cliente["id"])
    |> CartaoModel.create()
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
        "email" => params["email"],
        "fullname" => params["name"],
        "ownId" => params["ownId"],
        "birthDate" => params["birthDate"],
        "taxDocument" => params["taxDocument"],
        "phone" => params["phone"],
        "shippingAddress" => params["shippingAddress"]
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

  def wirecard_cliente(params) do
    %{
      "ownId" => params["uid"],
      "fullname" => params["name"],
      "email" => params["email"],
      "birthDate" => params["birthDate"],
      "taxDocument" => %{
        "type" => "CPF",
        "number" => params["number"]
      },
      "phone" => %{
        "countryCode" => "55",
        "areaCode" => String.slice(params["phone"], 0, 2),
        "number" => String.slice(params["phone"], 2, 20)
      },
      "shippingAddress" => %{
        "city" => params["city"],
        "district" => params["district"],
        "street" => params["street"],
        "streetNumber" => params["streetNumber"],
        "zipCode" => params["zipCode"],
        "state" => params["state"],
        "country" => "BRA",
        "complement" => params["complement"]
      }
    }
  end
end
