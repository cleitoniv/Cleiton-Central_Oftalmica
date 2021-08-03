defmodule Tecnovix.Repo.Migrations.CreateFieldRole do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :role, :string
    end
  end
end
