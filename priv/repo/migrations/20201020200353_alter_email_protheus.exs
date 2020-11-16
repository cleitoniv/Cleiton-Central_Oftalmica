defmodule Tecnovix.Repo.Migrations.AlterEmailProtheus do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :email_protheus, :string
    end
  end
end
