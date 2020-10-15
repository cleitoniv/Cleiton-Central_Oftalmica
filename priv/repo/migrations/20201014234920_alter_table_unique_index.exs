defmodule Tecnovix.Repo.Migrations.AlterTableUniqueIndex do
  use Ecto.Migration

  def change do
    execute("DROP INDEX public.clientes_constraint")
  end
end
