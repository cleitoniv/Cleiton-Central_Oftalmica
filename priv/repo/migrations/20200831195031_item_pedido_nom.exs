defmodule Tecnovix.Repo.Migrations.ItemPedidoNom do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :produto
      add :produto, :string, size: 256
    end
  end
end
