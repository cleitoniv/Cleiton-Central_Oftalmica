defmodule Tecnovix.Repo.Migrations.AlterItensPedidos do
  use Ecto.Migration

  def change do
    alter table(:itens_dos_pedidos_de_venda) do
      remove :descricao_generica_do_produto_id
      add :descricao_generica_do_produto_id, references(:descricao_generica_do_produto)
    end
  end
end
