defmodule Tecnovix.Repo.Migrations.AlterNumeroToString do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :numero
      add :numero, :string
    end
  end
end
