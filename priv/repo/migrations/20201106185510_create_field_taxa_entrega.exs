defmodule Tecnovix.Repo.Migrations.CreateFieldTaxaEntrega do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :taxa_entrega, :integer
    end
  end
end
