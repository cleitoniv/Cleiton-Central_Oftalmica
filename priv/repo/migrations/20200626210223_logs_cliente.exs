defmodule Tecnovix.Repo.Migrations.LogsCliente do
  use Ecto.Migration

  def change do
    create table(:logs_cliente) do
      add :cliente_id, references(:clientes)
      add :uid, :string, size: 45
      add :usuario_cliente_id, references(:usuarios_cliente)
      add :data, :utc_datetime
      add :ip, :string, size: 45
      add :dispositivo, :string, size: 255
      add :acao_realizada, :string

      timestamps()
    end
  end
end
