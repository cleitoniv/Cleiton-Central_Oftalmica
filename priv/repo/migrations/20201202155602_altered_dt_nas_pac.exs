defmodule Tecnovix.Repo.Migrations.AlteredDtNasPac do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :dt_nas_pac
      add :dt_nas_pac, :date
    end
  end
end
