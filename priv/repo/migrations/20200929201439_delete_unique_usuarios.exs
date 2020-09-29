defmodule Tecnovix.Repo.Migrations.DeleteUniqueUsuarios do
  use Ecto.Migration

  def change do
    drop index(:usuarios_cliente, [:cliente_id])
  end
end
