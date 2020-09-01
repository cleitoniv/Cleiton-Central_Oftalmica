defmodule Tecnovix.Repo.Migrations.AlterItensPedidosVirtotal do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :virtotal
      add :virtotal, :integer
    end
  end
end
