defmodule Tecnovix.Repo.Migrations.DropIndexTelefone do
  use Ecto.Migration

  def change do
    execute("DROP INDEX public.telefone_unico")
  end
end
