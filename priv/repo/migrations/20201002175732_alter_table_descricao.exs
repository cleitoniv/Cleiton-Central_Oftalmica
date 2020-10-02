defmodule Tecnovix.Repo.Migrations.AlterTableDescricao do
  use Ecto.Migration

  def change do
    alter table(:descricao_generica_do_produto) do
      remove :codigo
      add :codigo, :string
    end
  end
end
