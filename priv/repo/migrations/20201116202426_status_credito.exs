defmodule Tecnovix.Repo.Migrations.StatusCredito do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      add :status, :integer
    end
  end
end
