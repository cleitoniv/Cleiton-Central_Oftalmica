defmodule Tecnovix.Repo.Migrations.AlterTableItensPedidoDtNasPac do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :dt_nas_pac
      add :dt_nas_pac, :date
    end
  end
end
