defmodule Tecnovix.Repo.Migrations.AlterTableCliente do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :estado, :string
    end
  end
end
