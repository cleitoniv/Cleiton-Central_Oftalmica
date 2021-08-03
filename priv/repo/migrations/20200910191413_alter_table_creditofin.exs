defmodule Tecnovix.Repo.Migrations.AlterTableCreditofin do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      remove :valor
      add :valor, :integer
    end
  end
end
