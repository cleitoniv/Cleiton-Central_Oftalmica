defmodule Tecnovix.Repo.Migrations.AlterDev do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      add :olho, :string
    end
  end
end
