defmodule Tecnovix.Repo.Migrations.Schedules do
  use Ecto.Migration

  def change do
    create table(:agendas) do
      add :cliente_id, references(:clientes)
      add :date, :string
      add :turno_manha, :boolean
      add :turno_tarde, :boolean
      add :temporizador, :string
      add :visitado, :integer
      add :vendedor_id, references(:vendedores)

      timestamps()
    end
  end
end
