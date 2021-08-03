defmodule Tecnovix.Repo.Migrations.CreateFieldTaxa do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :taxa_wirecard, :integer
      remove :frete
    end
  end
end
