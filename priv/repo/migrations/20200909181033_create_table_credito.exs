defmodule Tecnovix.Repo.Migrations.CreateTableCredito do
  use Ecto.Migration

  def change do
    rename table(:opcoes_compra_credito_fianceiro), to: table(:opcoes_compra_credito_financeiro)

    alter table(:opcoes_compra_credito_financeiro) do
      remove :valor
      add :valor, :integer
      add :prestacoes, :integer
    end
  end
end
