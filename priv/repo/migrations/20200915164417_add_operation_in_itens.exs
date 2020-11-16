defmodule Tecnovix.Repo.Migrations.AddOperationInItens do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :operation, :string, size: 20
    end

    alter table(:pedidos_de_venda) do
      remove :operation
    end
  end
end
