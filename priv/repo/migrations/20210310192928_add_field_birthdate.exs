defmodule Tecnovix.Repo.Migrations.AddFieldBirthdate do
  use Ecto.Migration

  def change do
    alter table(:vendedores) do
      add :data_nascimento, :string
    end
  end
end
