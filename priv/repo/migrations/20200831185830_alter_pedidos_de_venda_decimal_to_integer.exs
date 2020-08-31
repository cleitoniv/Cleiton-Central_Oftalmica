defmodule Tecnovix.Repo.Migrations.AlterPedidosDeVendaDecimalToInteger do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :quantidade
      remove :prc_unitario
      add :quantidade, :integer
      add :prc_unitario, :integer
    end
  end
end
