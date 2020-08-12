defmodule Tecnovix.Repo.Migrations.ItemPreDevolucao do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :pre_devolucao_id
      add :pre_devolucao_id, references(:pre_devolucao)
    end
  end
end
