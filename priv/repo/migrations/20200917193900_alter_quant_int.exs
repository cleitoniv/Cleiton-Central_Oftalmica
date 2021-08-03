defmodule Tecnovix.Repo.Migrations.AlterQuantInt do
  use Ecto.Migration

  def change do
    alter table(:itens_pre_devolucao) do
      remove :quant
      add :quant, :integer
    end
  end
end
