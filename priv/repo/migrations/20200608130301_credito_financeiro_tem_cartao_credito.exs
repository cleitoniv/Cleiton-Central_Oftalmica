defmodule Tecnovix.Repo.Migrations.CreditoFinanceiroTemCartaoCredito do
  use Ecto.Migration

  def change do
    create table(:credito_financeiro_tem_cartao_credito) do
      add :credito_financeiro_id, :integer
      add :cartao_credito_id, :integer

      timestamps()
    end
  end
end
