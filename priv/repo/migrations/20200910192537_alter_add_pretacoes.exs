defmodule Tecnovix.Repo.Migrations.AlterAddPretacoes do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      add :prestacoes, :integer
    end
  end
end
