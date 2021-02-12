defmodule Tecnovix.Repo.Migrations.FieldProdutoTest do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      add :produto_teste, :string
    end
  end
end
