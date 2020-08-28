defmodule Tecnovix.Repo.Migrations.AlterClientes do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :cod_cnae
      add :cod_cnae, :string, size: 9
    end
  end
end
