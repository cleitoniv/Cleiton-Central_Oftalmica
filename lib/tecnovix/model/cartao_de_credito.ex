defmodule Tecnovix.CartaoDeCreditoModel do
  use Tecnovix.DAO, schema: Tecnovix.CartaoCreditoClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.CartaoCreditoClienteSchema, as: CartaoSchema
  import Ecto.Query

  def get_cc(%{"cliente_id" => cliente_id}) do
    query =
      from c in CartaoSchema,
        where: c.cliente_id == ^cliente_id and c.status == 1,
        update: [inc: [status: -1]]

    {:ok, Repo.update_all(query, [])}
  end

  def detail_card(params, cliente) when is_list(params) do
    card =
      Enum.map(
        params,
        fn map ->
          map
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
        end
      )

    {:ok, card}
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

  def primeiro_cartao(params, cliente_id) do
    cartao =
      case get_cards(cliente_id) do
        [] -> Map.put(params, "status", 1)
        _ -> params
      end

    {:ok, cartao}
  end

  def get_cards(cliente_id) do
    query =
      from c in CartaoSchema,
        where: c.cliente_id == ^cliente_id

    Repo.all(query)
  end
end
