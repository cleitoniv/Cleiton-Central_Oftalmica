defmodule Tecnovix.CartaoCreditoClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cartao_credito_cliente" do
    field :cliente_id, :integer
    field :nome_titular, :string
    field :cpf_titular, :string
    field :telefone_titular, :string
    field :data_nascimento_titular, :date
    field :primeiros_6_digitos, :string
    field :ultimos_4_digitos, :string
    field :mes_validade, :integer
    field :ano_validade, :integer
    field :bandeira, :string
    field :status, :integer
    field :wirecard_cartao_credito_id, :string
    field :wirecard_cartao_credito_hash, :string
    field :cep_endereco_cobranca, :string
    field :logradouro_endereco_cobranca, :string
    field :numero_endereco_cobranca, :string
    field :complemento_endereco_cobranca, :string
    field :bairro_enderco_cobranca, :string
    field :cidade_endereco_cobranca, :string
    field :estado_endereco_cobranca, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:client_id, :nome_titular, :cpf_titular, :telefone_titular, :data_nascimento_titular,
    :primeiros_6_digitos, :ultimos_4_digitos, :mes_validade, :ano_validade, :bandeira, :status, :wirecard_cartao_credito_id,
    :wirecard_cartao_credito_hash, :cep_endereco_cobranca, :logradouro_endereco_cobranca, :numero_endereco_cobranca,
    :complemento_endereco_cobranca, :bairro_endereco_cobranca, :cidade_endereco_cobranca, :estado_endereco_cobranca])
    |> validate_required([:client_id, :nome_titular, :cpf_titular, :primeiros_6_digitos, :ultimos_4_digitos, :mes_validade,
    :ano_validade, :status])
  end
end
