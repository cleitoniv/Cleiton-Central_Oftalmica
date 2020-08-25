defmodule Tecnovix.Repo.Migrations.AlterPreDevolucao do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :descricao_generica_do_produto_id
      add :descricao_generica_do_produto_id, references(:descricao_generica_do_produto)
    end
  end
end
