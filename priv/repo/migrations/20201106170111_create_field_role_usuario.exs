defmodule Tecnovix.Repo.Migrations.CreateFieldRoleUsuario do
  use Ecto.Migration

  def change do
    alter table(:usuarios_cliente) do
      add :role, :string
    end
  end
end
