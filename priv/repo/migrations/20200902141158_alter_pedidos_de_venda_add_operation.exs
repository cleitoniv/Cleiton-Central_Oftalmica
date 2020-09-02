defmodule Tecnovix.Repo.Migrations.AlterPedidosDeVendaAddOperation do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :operation, :string, size: 20
    end
  end
end
