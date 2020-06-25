defmodule Tecnovix.Repo.Migrations.CreditoFinanceiro do
  use Ecto.Migration

  def change do
    create table(:credito_financeiro) do
      add :cliente_id, :integer
      add :valor, :decimal
      add :desconto, :integer
      add :tipo_pagamento, :string
      add :wirecard_pedido_id, :string, size: 45
      add :wirecard_pagamento_id, :string, size: 45
      add :wirecard_reembolso_id, :string, size: 45

      timestamps()
    end
  end
end
