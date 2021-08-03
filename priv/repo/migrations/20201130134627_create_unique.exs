defmodule Tecnovix.Repo.Migrations.CreateUnique do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :serie
      remove :serie_saida
      add :serie_saida, :string
    end

    create unique_index(:itens_pre_devolucao, :num_de_serie)
  end
end
