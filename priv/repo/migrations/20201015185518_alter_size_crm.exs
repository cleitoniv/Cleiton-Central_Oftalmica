defmodule Tecnovix.Repo.Migrations.AlterSizeCrm do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :crm_medico
      add :crm_medico, :string
    end
  end
end
