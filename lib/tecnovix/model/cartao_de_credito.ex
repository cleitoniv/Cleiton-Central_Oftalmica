defmodule Tecnovix.CartaoDeCreditoModel do
  use Tecnovix.DAO, schema: Tecnovix.CartaoCreditoClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.ClientesSchema
  alias Tecnovix.CartaoCreditoClienteSchema, as: CreditoSchema
  alias Ecto.Multi
  import Ecto.Query

  def get_cc(%{"cliente_id" => cliente_id}) do
    CreditoSchema
    |> where([c], c.cliente_id == ^cliente_id)
  end

  def create_cc(params = %{"status" => 1}) do
    Multi.new()
    |> Multi.update_all(Ecto.UUID.autogenerate(), get_cc(params), set: [status: 0])
    |> Multi.insert(Ecto.UUID.autogenerate(), CreditoSchema.changeset(%CreditoSchema{}, params))
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
          "number" => String.slice(cliente.telefone, 2..11)
          },
        "shippingAddress" => %{
          "city" => cliente.municipio,
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

  # def order_params(usuario_ciente = %UsuariosClienteSchema{}, items) do
  #   usuario_cliente = Repo.preload(usuario_cliente, :cliente)
  # end

  def get_cartao_cliente(id) do
    case Repo.get_by(CreditoSchema, id: id) do
      nil ->
        {:error, :cartao_not_found}
      cartao_cliente ->
        {:ok, cartao_cliente}
    end
  end
end
