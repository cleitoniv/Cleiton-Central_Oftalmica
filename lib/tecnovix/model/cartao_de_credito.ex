defmodule Tecnovix.CartaoDeCreditoModel do
  use Tecnovix.DAO, schema: Tecnovix.CartaoCreditoClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema
  alias Tecnovix.CartaoCreditoClienteSchema, as: CartaoSchema
  alias Ecto.Multi
  import Ecto.Query

  def get_cc(%{"cliente_id" => cliente_id}) do
    CartaoSchema
    |> where([c], c.cliente_id == ^cliente_id)
  end

  def create_cc(params = %{"status" => 1}) do
    Multi.new()
    |> Multi.update_all(Ecto.UUID.autogenerate(), get_cc(params), set: [status: 0])
    |> Multi.insert(Ecto.UUID.autogenerate(), CartaoSchema.changeset(%CartaoSchema{}, params))
    |> Repo.transaction()
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

  def order_params(usuario_cliente = %UsuariosClienteSchema{}, items) do
    usuario_cliente = Repo.preload(usuario_cliente, :cliente)

    __MODULE__.order_params(usuario_cliente.cliente, items)
  end

  def payment_params({:ok, cartao = %CartaoSchema{}}) do
    %{
      "installmentCount" => 6,
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
              "type" => "CPF",
              "number" => cartao.cpf_titular
            },
            "phone" => %{
              "countryCode" => String.slice(cartao.telefone_titular, 0..1),
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

  def detail_card(params, cliente) do
    card =
      params
      |> Map.put("cliente_id", cliente.id)
      |> Map.put("cpf_titular", cliente.cnpj_cpf)
      |> Map.put("telefone_titular", cliente.telefone)
      |> Map.put("data_nascimento_titular", cliente.data_nascimento)
      |> Map.put("cep_endereco_cobranca", cliente.cep)
      |> Map.put("logradouro_endereco_cobranca", cliente.endereco)
      |> Map.put("numero_endereco_cobranca", cliente.numero)
      |> Map.put("complemento_endereco_cobranca", cliente.complemento)
      |> Map.put("bairro_endereco_cobranca", cliente.bairro)
      |> Map.put("cidade_endereco_cobranca", cliente.municipio)

    {:ok, card}
  end

  def get_cartao_cliente(id) do
    case Repo.get_by(CartaoSchema, id: id) do
      nil ->
        {:error, :cartao_not_found}

      cartao_cliente ->
        {:ok, cartao_cliente}
    end
  end
end
