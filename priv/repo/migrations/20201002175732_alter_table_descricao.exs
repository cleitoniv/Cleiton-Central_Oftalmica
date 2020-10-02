defmodule Tecnovix.Repo.Migrations.AlterTableDescricao do
  use Ecto.Migration

  def change do
    remove :codigo
    add :codigo, :string
  end
end
