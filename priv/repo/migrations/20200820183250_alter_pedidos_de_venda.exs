defmodule Tecnovix.Repo.Migrations.AlterPedidosDeVenda do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :order_id, :string
    end
  end
end
