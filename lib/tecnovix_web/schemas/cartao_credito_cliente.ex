defmodule Tecnovix.CartaoCreditoClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cartao_credito_cliente" do
    field :nome_titular, :string
    field :cpf_titular, :string
    field :telefone_titular, :string
    field :data_nascimento_titular, :date
    field :primeiros_6_digitos, :string
    field :ultimos_4_digitos, :string
    field :mes_validade, :string
    field :cartao_number, :string
    field :ano_validade, :string
    field :bandeira, :string
    field :status, :integer, default: 1
    field :wirecard_cartao_credito_id, :string
    field :wirecard_cartao_credito_hash, :string
    field :cep_endereco_cobranca, :string
    field :logradouro_endereco_cobranca, :string
    field :numero_endereco_cobranca, :string
    field :complemento_endereco_cobranca, :string
    field :bairro_endereco_cobranca, :string
    field :cidade_endereco_cobranca, :string
    field :estado_endereco_cobranca, :string
    belongs_to :cliente, Tecnovix.ClientesSchema

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :nome_titular,
      :cpf_titular,
      :telefone_titular,
      :data_nascimento_titular,
      :primeiros_6_digitos,
      :ultimos_4_digitos,
      :mes_validade,
      :ano_validade,
      :bandeira,
      :status,
      :wirecard_cartao_credito_id,
      :wirecard_cartao_credito_hash,
      :cep_endereco_cobranca,
      :logradouro_endereco_cobranca,
      :numero_endereco_cobranca,
      :complemento_endereco_cobranca,
      :bairro_endereco_cobranca,
      :cidade_endereco_cobranca,
      :estado_endereco_cobranca,
      :cartao_number
    ])
    |> validate_required([
      :cliente_id,
      :nome_titular,
      :cpf_titular,
      :mes_validade,
      :ano_validade
    ])
    |> unique_constraint(:cartao_number, message: "Já existe um cartão com esse número.")
  end
end
