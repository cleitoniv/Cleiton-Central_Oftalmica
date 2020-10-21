defmodule Tecnovix.Repo.Migrations.CreateIndexTelefone do
  use Ecto.Migration

  def change do
      create unique_index(:clientes, :telefone)
  end
end
