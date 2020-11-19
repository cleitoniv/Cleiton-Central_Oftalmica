defmodule Tecnovix.Repo.Migrations.CreateFieldStatusItem do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :status, :integer
    end
  end
end
