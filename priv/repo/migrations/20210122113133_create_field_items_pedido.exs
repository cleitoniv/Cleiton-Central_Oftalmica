defmodule Tecnovix.Repo.Migrations.CreateFieldItemsPedido do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :valor_test, :integer
    end
  end
end
