defmodule Tecnovix.Repo.Migrations.FieldApelido do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :apelido, :string
    end
  end
end
