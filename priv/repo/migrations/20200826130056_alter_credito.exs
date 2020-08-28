defmodule Tecnovix.Repo.Migrations.AlterCredito do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      remove :cliente_id
      add :cliente_id, references(:clientes)
    end
  end
end
