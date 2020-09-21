defmodule Tecnovix.Repo.Migrations.RescuePoints do
  use Ecto.Migration

  def change do
    create table(:rescue_points) do
      add :cliente_id, references(:clientes)
      add :points, :integer
      add :credit_finan, :integer

      timestamps()
    end
  end
end
