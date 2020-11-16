defmodule Tecnovix.Repo.Migrations.AlterPoints do
  use Ecto.Migration

  def change do
    alter table(:points) do
      remove :points
      add :points, :integer
      add :credit_finan, :integer
    end
  end
end
