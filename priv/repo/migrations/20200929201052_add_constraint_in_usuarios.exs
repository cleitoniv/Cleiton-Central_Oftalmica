defmodule Tecnovix.Repo.Migrations.AddConstraintInUsuarios do
  use Ecto.Migration

  def change do
    create unique_index(:usuarios_cliente, :email)
  end
end
