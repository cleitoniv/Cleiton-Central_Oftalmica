defmodule Tecnovix.Repo.Migrations.AlterItemPedidoDtPac do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :dt_nas_pac
      add :dt_nas_pac, :string, size: 10
    end
  end
end
