defmodule Tecnovix.Repo.Migrations.OpcoesCompraCreditoFinanceiro do
  use Ecto.Migration

  def change do
    create table(:opcoes_compra_credito_fianceiro) do
      add :valor, :decimal
      add :desconto, :integer

      timestamps()
    end
  end
end
