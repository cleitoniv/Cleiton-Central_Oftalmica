defmodule Tecnovix.Repo.Migrations.CreditoFinanStatusPago do
  use Ecto.Migration

  def change do
    alter table(:credito_financeiro) do
      add :pago, :integer
    end
  end
end
