defmodule Tecnovix.Repo.Migrations.LogsVendedor do
  use Ecto.Migration

  def change do
    create table(:logs_vendedor) do
      add :vendedor_id, references(:vendedores)
      add :data, :utc_datetime
      add :ip, :string, size: 45
      add :dispositivo, :string, size: 255

      timestamps()
    end
  end
end
