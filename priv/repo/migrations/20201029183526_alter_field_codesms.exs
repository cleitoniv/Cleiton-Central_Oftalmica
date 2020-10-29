defmodule Tecnovix.Repo.Migrations.AlterFieldCodesms do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      remove :code_sms
      add :code_sms, :integer
    end
  end
end
