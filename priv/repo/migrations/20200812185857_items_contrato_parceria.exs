defmodule Tecnovix.Repo.Migrations.ItemsContratoParceria do
  use Ecto.Migration

  def change do
    alter table(:itens_do_contrato_parceria) do
      remove :contrato_de_parceria_id
      add :contrato_de_parceria_id, references(:contrato_de_parceria)
    end
  end
end
