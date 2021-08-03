defmodule Tecnovix.Repo.Migrations.AlterContratoAddOrderId do
  use Ecto.Migration

  def change do
    alter table(:contrato_de_parceria) do
      add :order_id, :string
    end
  end
end
