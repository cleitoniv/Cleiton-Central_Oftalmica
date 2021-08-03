defmodule Tecnovix.Repo.Migrations.AddFieldPago do
  use Ecto.Migration

  def change do
    alter table(:pedidos_de_venda) do
      add :pago, :string
    end
  end
end
