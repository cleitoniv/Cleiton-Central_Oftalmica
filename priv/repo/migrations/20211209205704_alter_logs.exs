defmodule Tecnovix.Repo.Migrations.AlterLogs do
  use Ecto.Migration

  def change do
      alter table(:logs_cliente) do
        remove :usuario_cliente_id
        add :usuario_cliente_id, references(:usuarios_cliente, on_delete: :delete_all)
    end
  end
end
