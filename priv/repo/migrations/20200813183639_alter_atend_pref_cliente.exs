defmodule Tecnovix.Repo.Migrations.AlterAtendPrefCliente do
  use Ecto.Migration

  def change do
    alter table(:atend_pref_cliente) do
      remove :cliente_id
      add :cliente_id, references(:clientes)
    end
  end
end
