defmodule Tecnovix.Repo.Migrations.AlterData do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :dt_nas_pac
      add :dt_nas_pac, :string
    end
  end
end
