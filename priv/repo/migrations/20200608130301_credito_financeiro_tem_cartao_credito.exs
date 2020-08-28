defmodule Tecnovix.Repo.Migrations.CreditoFinanceiroTemCartaoCredito do
  use Ecto.Migration

  def change do
    create table(:credito_financeiro_tem_cartao_credito) do
      add :credito_financeiro_id, references(:credito_financeiro)
      add :cartao_credito_id, references(:cartao_credito_cliente)

      timestamps()
    end
  end
end
