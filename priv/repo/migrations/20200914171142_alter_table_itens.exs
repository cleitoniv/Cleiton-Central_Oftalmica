defmodule Tecnovix.Repo.Migrations.AlterTableItens do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :codigo, :string, size: 15
    end
  end
end
