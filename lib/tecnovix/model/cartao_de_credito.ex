defmodule Tecnovix.CartaoDeCreditoModel do
  use Tecnovix.DAO, schema: Tecnovix.CartaoCreditoClienteSchema
  alias Tecnovix.Repo
  alias Tecnovix.CartaoCreditoClienteSchema, as: CartaoSchema
  import Ecto.Query

  def select_card(id, cliente) do
    case get_cc(%{"cliente_id" => cliente.id}) do
      {:ok, _list} ->
        cartao =
          CartaoSchema
          |> where([c], c.id == ^id and c.cliente_id == ^cliente.id)
          |> update([c], inc: [status: 1])
          |> Repo.update_all([])

        {:ok, cartao}

      _ ->
        {:error, :not_found}
    end
  end

  def delete_card(id, cliente) do
    CartaoSchema
    |> where([c], c.id ==^id and ^cliente.id == c.cliente_id)
    |> first()
    |> Repo.one()
    |> Repo.delete()
  end

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
          |> Map.put("telefone_titular", "#{cliente.ddd}" <> "#{cliente.telefone}")
          |> Map.put("data_nascimento_titular", cliente.data_nascimento)
          |> Map.put("cep_endereco_cobranca", cliente.cep)
          |> Map.put("logradouro_endereco_cobranca", cliente.endereco)
          |> Map.put("numero_endereco_cobranca", cliente.numero)
          |> Map.put("complemento_endereco_cobranca", cliente.complemento)
          |> Map.put("bairro_endereco_cobranca", cliente.bairro)
          |> Map.put("cidade_endereco_cobranca", cliente.municipio)
          |> Map.put("estado_endereco_cobranca", cliente.estado)
        end
      )

    {:ok, card}
  end

  def detail_card(params, cliente) do
    telefone =
      case cliente.telefone do
        "55" <> telefone -> "55" <> "#{cliente.ddd}" <> "#{telefone}"
        telefone -> "55" <> "#{cliente.ddd}" <> "#{telefone}"
      end

    card =
      params
      |> Map.put("cliente_id", cliente.id)
      |> Map.put("cpf_titular", cliente.cnpj_cpf)
      |> Map.put("telefone_titular", telefone)
      |> Map.put("data_nascimento_titular", cliente.data_nascimento)
      |> Map.put("cep_endereco_cobranca", cliente.cep)
      |> Map.put("logradouro_endereco_cobranca", cliente.endereco)
      |> Map.put("numero_endereco_cobranca", cliente.numero)
      |> Map.put("complemento_endereco_cobranca", cliente.complemento)
      |> Map.put("bairro_endereco_cobranca", cliente.bairro)
      |> Map.put("cidade_endereco_cobranca", cliente.municipio)
      |> Map.put("estado_endereco_cobranca", cliente.estado)

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
