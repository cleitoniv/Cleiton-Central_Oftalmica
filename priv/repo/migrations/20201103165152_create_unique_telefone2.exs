defmodule Tecnovix.Repo.Migrations.CreateUniqueTelefone2 do
  use Ecto.Migration

  def change do
    create unique_index(:clientes, :telefone)
  end
end
