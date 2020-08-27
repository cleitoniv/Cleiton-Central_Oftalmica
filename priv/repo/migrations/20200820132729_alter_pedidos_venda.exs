defmodule Tecnovix.Repo.Migrations.AlterPedidosVenda do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      remove :cliente_id
      add :client_id, references(:clientes)
    end
  end
end
