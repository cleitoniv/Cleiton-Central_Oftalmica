defmodule Tecnovix.Repo.Migrations.CartaoCreditoCliente do
  use Ecto.Migration

  def change do
    create table(:cartao_credito_cliente) do
      add :cliente_id, :integer
      add :nome_titular, :string, size: 255
      add :cpf_titular, :string, size: 11
      add :telefone_titular, :string, size: 45
      add :data_nascimento_titular, :date
      add :primeiros_6_digitos, :string, size: 6
      add :ultimos_4_digitos, :string, size: 4
      add :mes_validade, :integer
      add :ano_validade, :integer
      add :bandeira, :string, size: 45
      add :status, :integer, default: 1
      add :wirecard_cartao_credito_id, :string, size: 45
      add :wirecard_cartao_credito_hash, :string
      add :cep_endereco_cobranca, :string, size: 8
      add :logradouro_endereco_cobranca, :string, size: 255
      add :numero_endereco_cobranca, :string, size: 45
      add :complemento_endereco_cobranca, :string, size: 45
      add :bairro_endereco_cobranca, :string, size: 45
      add :cidade_endereco_cobranca, :string, size: 45
      add :estado_endereco_cobranca, :string, size: 45

      timestamps()
    end
  end
end
