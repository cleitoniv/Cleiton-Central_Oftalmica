defmodule Tecnovix.Repo.Migrations.CreditCardUnique do
  use Ecto.Migration

  def change do
    drop index(:cartao_credito_cliente, [:cartao_number])
    create unique_index(:cartao_credito_cliente, [:cartao_number, :cliente_id])
  end
end
