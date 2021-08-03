defmodule Tecnovix.Repo.Migrations.AlterEmail do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :email_protheus
    end
  end
end
