defmodule Tecnovix.Repo.Migrations.AlterTableItensPedidosAdd do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :codigo_item, :string
    end
  end
end
