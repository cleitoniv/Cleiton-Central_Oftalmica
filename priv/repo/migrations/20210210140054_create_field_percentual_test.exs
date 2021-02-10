defmodule Tecnovix.Repo.Migrations.CreateFieldPercentualTest do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :percentage_test, :integer
    end
  end
end
