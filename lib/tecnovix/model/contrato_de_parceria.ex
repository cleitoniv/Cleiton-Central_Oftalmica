defmodule Tecnovix.ContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.ClientesSchema
  alias Tecnovix.PedidosDeVendaModel

  def insert_or_update(%{"data" => data} = params) when is_list(data) do
    {:ok,
     Enum.map(params["data"], fn contrato ->
       with nil <-
              Repo.get_by(ContratoDeParceriaSchema,
                filial: contrato["filial"],
                contrato_n: contrato["contrato_n"]
              ) do
         create(contrato)
       else
         changeset ->
           Repo.preload(changeset, :items)
           |> __MODULE__.update(contrato)
       end
     end)}
  end

  def insert_or_update(%{"filial" => filial, "contrato_n" => contrato_n} = params) do
    with nil <- Repo.get_by(ContratoDeParceriaSchema, filial: filial, contrato_n: contrato_n) do
      __MODULE__.create(params)
    else
      contrato ->
        {:ok, contrato}
    end
  end

  def insert_or_update(_params) do
    {:error, :invalid_parameter}
  end

  def order(cliente, items) do
    cliente
    |> organize_order(items)
    |> wirecard_order()
    |> Wirecard.create_order()
  end

  def organize_order(cliente = %ClientesSchema{}, items) do
    fisica_jurid =
      case cliente.fisica_jurid do
        "F" -> "CPF"
        "J" -> "CNPJ"
      end

    %{
      "ownId" => Ecto.UUID.autogenerate(),
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
          "number" => "12345678901"
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
          "state" => "SP",
          "country" => "BRA"
        }
      }
    }
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

  def items_order(items) do
    order_items =
      Enum.map(items["items"], fn order ->
        %{
          "product" => order["produto"],
          "category" => "OTHER_CATEGORIES",
          "quantity" => order["quantidade"],
          "detail" => "Mais info...",
          "price" => order["preco_venda"]
        }
      end)

    {:ok, order_items}
  end

  def create_contrato(cliente, items, order) do
    cliente
    |> organize_contrato(items, order)
    |> __MODULE__.create()
  end

  def organize_contrato(cliente, items, order) do
    {:ok, order} = Jason.decode(order.body)

    %{
      "order_id" => order["id"],
      "client_id" => cliente.id,
      "filial" => "",
      "contrato_n" => "",
      "docto_orig" => "",
      "cliente" => cliente.codigo,
      "loja" => cliente.loja,
      "items" =>
        Enum.map(
          items["items"],
          fn item ->
            %{
              "contrato_de_parceria_id" => 1,
              "descricao_generica_do_produto_id" => item["descricao_generica_do_produto_id"],
              "filial" => item["filial"],
              "contrato_n" => item["contrato_n"],
              "item" => item["item"],
              "produto" => item["produto"],
              "quantidade" => item["quantidade"],
              "preco_venda" => item["preco_venda"],
              "total" => item["preco_venda"] * item["quantidade"],
              "cliente" => cliente.codigo,
              "loja" => cliente.loja
            }
          end
        )
    }
  end

  def payment(cartao_id, order, ccv, installment) do
    order = Jason.decode!(order.body)
    order_id = order["id"]

    payment =
      cartao_id
      |> PedidosDeVendaModel.get_cartao_cliente()
      |> PedidosDeVendaModel.payment_params(ccv, installment)
      |> PedidosDeVendaModel.wirecard_payment()
      |> Wirecard.create_payment(order_id)

    case payment do
      {:ok, %{status_code: 201}} -> payment
      _ -> {:error, :payment_not_created}
    end
  end

  def get_package(resp) do
    productPackages = Jason.decode!(resp.body) |> IO.inspect

    packages = Enum.flat_map(productPackages["resources"], fn resource ->
        Enum.map(resource["models"], fn model ->
          Enum.reduce(model["fields"], %{}, fn package, acc ->
            productPackages =
              case package["id"] do
                "DA1_PRCVEN" -> Map.put(acc, :price, package["value"])
                "DA1_QTDLOT" -> Map.put(acc, :quantity, package["value"])
                _ -> acc
              end
              |> IO.inspect

              Map.put(productPackages, :total, productPackages.price * productPackages.quantity) |> IO.inspect
          end)
        end)
    end)
    |> IO.inspect

    {:ok, packages}
  end
end
