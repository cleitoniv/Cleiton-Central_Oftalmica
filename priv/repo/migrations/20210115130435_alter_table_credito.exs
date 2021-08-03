defmodule Tecnovix.Repo.Migrations.AlterTableCredito do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      add(:saldo, :integer)
    end
  end
end
