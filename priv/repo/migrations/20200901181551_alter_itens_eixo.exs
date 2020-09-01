defmodule Tecnovix.Repo.Migrations.AlterItensEixo do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :eixo
      add :eixo, :decimal
    end
  end
end
