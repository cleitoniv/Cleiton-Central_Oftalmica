defmodule Tecnovix.Repo.Migrations.AlterCartao do
  use Ecto.Migration

  def change do
    alter table(:cartao_credito_cliente) do
      remove :cartao_number
      add :cartao_number, :string
      remove :mes_validade
      add :mes_validade, :string
      remove :ano_validade
      add :ano_validade, :string
    end
  end
end
