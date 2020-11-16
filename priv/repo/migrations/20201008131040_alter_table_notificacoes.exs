defmodule Tecnovix.Repo.Migrations.AlterTableNotificacoes do
  use Ecto.Migration

  def change do
    alter table(:notificacoes_cliente) do
      remove :lido
      add :lido, :boolean
    end
  end
end
