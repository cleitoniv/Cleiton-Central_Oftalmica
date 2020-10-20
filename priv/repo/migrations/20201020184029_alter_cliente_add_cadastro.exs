defmodule Tecnovix.Repo.Migrations.AlterClienteAddCadastro do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :cadastrado, :boolean
    end
  end
end
