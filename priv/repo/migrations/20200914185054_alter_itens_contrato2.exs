defmodule Tecnovix.Repo.Migrations.AlterItensContrato2 do
  use Ecto.Migration

  def change do
    alter table(:contrato_de_parceria) do
      add :pedido_id, references(:pedidos_de_venda)
    end
  end
end
