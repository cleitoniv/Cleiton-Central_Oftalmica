defmodule Tecnovix.CreditoFinanceiroModel do
  use Tecnovix.DAO, schema: Tecnovix.CreditoFinanceiroSchema
  alias Tecnovix.Repo
  alias Tecnovix.CreditoFinanceiroModel
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.ClientesSchema
  alias Tecnovix.CartaoCreditoClienteSchema, as: CartaoSchema
  alias Tecnovix.CreditoFinanceiroSchema, as: Credito
  import Ecto.Query

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(data, fn param ->
       with nil <-
              Repo.get_by(Credito, cliente_id: param["cliente_id"]) do
         {:ok, create} = create(param)
         create
       else
         changeset ->
           {:ok, update} = __MODULE__.update(changeset, param)
           update
       end
     end)}
  end

  def insert_or_update(%{"id" => id} = params) do
    with nil <- Repo.get(Credito, id) do
      __MODULE__.create(params)
    else
      changeset ->
        __MODULE__.update(changeset, params)
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def insert(params, order, payment, cliente_id) do
    case credito_params(params, order, payment, cliente_id) do
      {:ok, credito_params} -> create(credito_params)
      _ -> {:error, :payment_credit_fail}
    end
  end

  def credito_params(params, order, payment, cliente_id) do
    order_body = Jason.decode!(order.body)
    payment_body = Jason.decode!(payment.body)

    params = %{
      "cliente_id" => cliente_id,
      "valor" => Enum.reduce(params, 0, fn map, _acc -> map["valor"] end),
      "desconto" => Enum.reduce(params, 0, fn map, _acc -> map["desconto"] end),
      "prestacoes" => Enum.reduce(params, 0, fn map, _acc -> map["prestacoes"] end),
      "tipo_pagamento" => payment_body["fundingInstrument"]["method"],
      "wirecard_pedido_id" => order_body["id"],
      "wirecard_pagamento_id" => payment_body["id"],
      "wirecard_reembolso_id" => ""
    }

    {:ok, params}
  end

  def get_payments(cliente_id) do
    pedidos =
      Credito
      |> where(
        [c],
        (c.cliente_id == ^cliente_id and c.status == 1) or
          (c.cliente_id == ^cliente_id and c.status == 3)
      )
      |> Repo.all()
      |> Enum.reduce([], fn pedido, acc ->
        acc ++ [pedido]
      end)

    {:ok, pedidos}
  end

  def order(params, cliente) do
    order =
      cliente
      |> __MODULE__.order_params(params)
      |> CreditoFinanceiroModel.wirecard_order()
      |> Wirecard.create_order()

    case order do
      {:ok, %{status_code: 201}} -> order
      _ -> {:error, :order_not_created}
    end
  end

  def wirecard_order(params) do
    {:ok,
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
     }}
  end

  def get_package(resp) do
    productPackages = Jason.decode!(resp.body)

    packages =
      Enum.flat_map(productPackages["resources"], fn resource ->
        Enum.map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn package, acc ->
            case package["id"] do
              "DA1_PRCVEN" ->
                Map.put(acc, :discount, transform_value(package["value"]))

              "DA1_YCONDP" ->
                Map.put(
                  acc,
                  :installmentCount,
                  String.at(package["value"], 0) |> String.to_integer()
                )

              "DA1_QTDLOT" ->
                Map.put(acc, :value, transform_value(package["value"]) * 100)

              _ ->
                acc
            end
          end)
        end)
      end)

    {:ok, packages}
  end

  def transform_value(string) do
    String.to_float(string)
    |> Float.ceil(0)
    |> Kernel.round()
  end

  def payment(id_cartao, order, params) do
    order = Jason.decode!(order.body)
    order_id = order["id"]

    payment =
      id_cartao
      |> CreditoFinanceiroModel.get_cartao_cliente()
      |> CreditoFinanceiroModel.payment_params(params)
      |> CreditoFinanceiroModel.wirecard_payment()
      |> Wirecard.create_payment(order_id)
      |> IO.inspect()

    case payment do
      {:ok, %{status_code: 201}} -> payment
      _ -> {:error, :payment_not_created}
    end
  end

  def wirecard_payment(params) do
    installmentCount =
      case params["installmentCount"] do
        0 -> 1
        installmentCount -> installmentCount
      end

    {:ok,
     %{
       "installmentCount" => installmentCount,
       "statementDescriptor" => params["statementDescriptor"],
       "fundingInstrument" => params["fundingInstrument"]
     }}
  end

  def order_params(cliente = %ClientesSchema{}, items) do
    fisica_jurid =
      case cliente.fisica_jurid do
        "F" -> "CPF"
        "J" -> "CNPJ"
      end

    %{
      "ownId" => cliente.codigo,
      "amount" => %{
        "currency" => "BRL",
        "subtotals" => %{
          "shipping" => 1000
        }
      },
      "items" => items,
      "customers" => %{
        "ownId" => cliente.codigo,
        "fullname" => cliente.nome,
        "email" => cliente.email,
        "birthDate" => cliente.data_nascimento,
        "taxDocument" => %{
          "type" => fisica_jurid,
          "number" => cliente.cnpj_cpf
        },
        "phone" => %{
          "countryCode" => "55",
          "areaCode" => cliente.ddd,
          "number" => cliente.telefone
        },
        "shippingAddress" => %{
          "city" => "Serra",
          "complement" => cliente.complemento,
          "district" => cliente.bairro,
          "street" => cliente.endereco,
          "streetNumber" => cliente.numero,
          "zipCode" => cliente.cep,
          "state" => cliente.estado,
          "country" => "BRA"
        }
      }
    }
  end

  def payment_params({:ok, cartao = %CartaoSchema{}}, params) do
    case(String.length(cartao.cpf_cnpj_titular)) do
      14 -> "CNPJ"
      11 -> "CPF"
    end

    %{
      "installmentCount" => Enum.reduce(params, 0, fn map, _acc -> map["prestacoes"] end),
      "statementDescriptor" => "central",
      "fundingInstrument" => %{
        "method" => "CREDIT_CARD",
        "creditCard" => %{
          "expirationYear" => String.slice(cartao.ano_validade, 2..3),
          "expirationMonth" => cartao.mes_validade,
          "number" => cartao.cartao_number,
          "cvc" => "123",
          "holder" => %{
            "fullname" => cartao.nome_titular,
            "birthdate" => Date.to_string(cartao.data_nascimento_titular),
            "taxDocument" => %{
              "type" =>
                case(String.length(cartao.cpf_cnpj_titular)) do
                  14 -> "CNPJ"
                  11 -> "CPF"
                end,
              "number" => cartao.cpf_cnpj_titular
            },
            "phone" => %{
              "countryCode" => "55",
              "areaCode" => String.slice(cartao.telefone_titular, 2..3),
              "number" => String.slice(cartao.telefone_titular, 4..13)
            },
            "billingAddress" => %{
              "city" => cartao.cidade_endereco_cobranca,
              "district" => cartao.bairro_endereco_cobranca,
              "street" => cartao.logradouro_endereco_cobranca,
              "streetNumber" => cartao.numero_endereco_cobranca,
              "zipCode" => cartao.cep_endereco_cobranca,
              "state" => cartao.estado_endereco_cobranca,
              "country" => "BRA"
            }
          }
        }
      }
    }
  end

  def get_cartao_cliente(id) do
    case Repo.get_by(CartaoSchema, id: id) do
      nil ->
        {:error, :cartao_not_found}

      cartao_cliente ->
        {:ok, cartao_cliente}
    end
  end

  def get_cliente_by_id(id) do
    case Repo.get_by(ClientesSchema, id: id) do
      nil -> :error
      cliente -> {:ok, cliente}
    end
  end

  def items_order(items) do
    order =
      Enum.map(items, fn map ->
        %{
          "product" => "Credito",
          "category" => "OTHER_CATEGORIES",
          "quantity" => 1,
          "detail" => "Compra de credito financeiro.",
          "price" => map["valor"]
        }
      end)

    {:ok, order}
  end

  def sum_credits(cliente) do
    Credito
    |> where([c], ^cliente.id == c.cliente_id)
    |> Repo.all()
    |> Enum.reduce(0, fn credit, acc ->
      credit.saldo + acc
    end)
  end

  def get_creditos_by_cliente(cliente_id) do
    credito =
      Credito
      |> where([c], c.cliente_id == ^cliente_id)
      |> Repo.all()
  end

  def get_credito_by_status(filtro) do
    creditos =
      Credito
      |> where([c], c.status == ^filtro)
      |> Repo.all()

    {:ok, creditos}
  end
end
