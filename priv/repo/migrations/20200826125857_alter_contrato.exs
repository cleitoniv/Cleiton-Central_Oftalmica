defmodule Tecnovix.Repo.Migrations.AlterContrato do
  use Ecto.Migration

  def change do
    alter table(:contrato_de_parceria) do
      remove :cliente_id
      add :client_id, references(:clientes)
    end
  end
end
