defmodule Tecnovix.Repo.Migrations.AlterCartaoCredito2 do
  use Ecto.Migration

  def change do
    alter table(:cartao_credito_cliente) do
      remove :mes_validade
      add :mes_validade, :string
      remove :ano_validade
      add :ano_validade, :string
    end
  end
end
