defmodule Tecnovix.Repo.Migrations.AlterItensContrato do
  use Ecto.Migration

  def change do
    alter table(:itens_do_contrato_parceria) do
      remove :quantidade
      add :quantidade, :integer
      remove :preco_venda
      add :preco_venda, :integer
      remove :total
      add :total, :integer
    end
  end
end
