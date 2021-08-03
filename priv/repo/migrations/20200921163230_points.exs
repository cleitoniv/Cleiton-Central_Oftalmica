defmodule Tecnovix.Repo.Migrations.Points do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :num_serie, :string
      add :paciente, :string
      add :num_pac, :string
      add :dt_nas_pac, :date
      add :points, :string
      add :status, :integer

      timestamps()
    end
  end
end
