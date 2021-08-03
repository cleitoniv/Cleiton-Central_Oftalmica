defmodule Tecnovix.Repo.Migrations.AlterTablePoints do
  use Ecto.Migration

  def change do
    alter table(:points) do
      remove :credit_finan
    end
  end
end
