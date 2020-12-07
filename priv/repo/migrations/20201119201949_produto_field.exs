defmodule Tecnovix.Repo.Migrations.ProdutoField do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :produto
      add :produto, :string
    end
  end
end
