defmodule Tecnovix.Repo.Migrations.ItemPedidoDeVenda do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :pedido_de_venda_id
      add :pedido_de_venda_id, references(:pedidos_de_venda)
    end
  end
end
