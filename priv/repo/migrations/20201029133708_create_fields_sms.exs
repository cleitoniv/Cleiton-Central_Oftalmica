defmodule Tecnovix.Repo.Migrations.CreateFieldsSms do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :confirmation_sms, :integer
      add :code_sms, :string
    end
  end
end
