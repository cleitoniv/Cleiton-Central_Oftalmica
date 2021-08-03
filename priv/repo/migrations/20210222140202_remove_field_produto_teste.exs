defmodule Tecnovix.Repo.Migrations.RemoveFieldProdutoTeste do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :produto_com_teste
    end
  end
end
