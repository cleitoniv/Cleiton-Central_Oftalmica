defmodule Tecnovix.Repo.Migrations.AlterContasReceber do
  use Ecto.Migration

  def change do
    alter table(:contas_a_receber) do
      remove :cliente_id
      add :client_id, references(:clientes)
    end
  end
end
