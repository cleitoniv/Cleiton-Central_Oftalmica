defmodule Tecnovix.Repo.Migrations.AlterTableDesc do
  use Ecto.Migration

  def change do
    alter table(:descricao_generica_do_produto) do
      remove :eixo
      add :eixo, :decimal
    end
  end
end
