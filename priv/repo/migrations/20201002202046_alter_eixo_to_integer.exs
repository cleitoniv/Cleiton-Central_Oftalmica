defmodule Tecnovix.Repo.Migrations.AlterEixoToInteger do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :eixo
      add :eixo, :integer
    end
  end
end
