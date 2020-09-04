defmodule Tecnovix.ContratoDeParceriaModel do
  use Tecnovix.DAO, schema: Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Repo
  alias Tecnovix.ContratoDeParceriaSchema
  alias Tecnovix.Resource.Wirecard.Actions, as: Wirecard
  alias Tecnovix.ClientesSchema

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
          "countryCode" => String.slice(cliente.telefone, 0..1),
          "areaCode" => cliente.ddd,
          "number" => String.slice(cliente.telefone, 4..13)
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
      Enum.flat_map(
        items,
        fn item ->
          Enum.map(item["items"], fn order ->
            %{
              "product" => order["produto"],
              "category" => "OTHER_CATEGORIES",
              "quantity" => order["quantidade"],
              "detail" => "Mais info...",
              "price" => order["prc_unitario"]
            }
          end)
        end
      )

    {:ok, order_items}
  end

  def create_contrato(cliente, items) do
    %{
      "client_id" => cliente.id,
      "filial" => "",
      "contrato_n" => "",
      "docto_orig" => "",
      "cliente" => cliente.codigo,
      "loja" => cliente.loja,
      "items" => [
        %{
          "descricao_generica_do_produto" => items["descricao_generica_do_produto"],
          "filial" => items["filial"],
          "contrato_n" => items["contrato_n"],
          "item" => items["item"],
          "produto" => items["produto"],
          "quantidade" => items["quantidade"],
          "preco_venda" => items["preco_venda"],
          "total" => items["preco_venda"] * items["quantidade"],
          "cliente" => cliente.codigo,
          "loja" => cliente.loja
        }
      ]
    }
  end
end
