defmodule Tecnovix.Repo.Migrations.AddFieldEmailFiscal do
  use Ecto.Migration

  def change do
    alter table(:clientes) do
      add :email_fiscal, :string
    end
  end
end
