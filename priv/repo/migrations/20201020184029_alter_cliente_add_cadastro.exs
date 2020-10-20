defmodule Tecnovix.Repo.Migrations.AlterClienteAddCadastro do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      :cadastrado, :boolean
    end
  end
end
