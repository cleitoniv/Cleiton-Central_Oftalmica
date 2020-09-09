defmodule Tecnovix.Repo.Migrations.AlterPedidoAddEntrega do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :previsao_entrega, :string
      add :frete, :integer
    end
  end
end
