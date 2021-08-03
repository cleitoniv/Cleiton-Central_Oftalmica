defmodule Tecnovix.Repo.Migrations.AlterTableClientes do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :confirmation_sms
      remove :code_sms
    end
  end
end
