defmodule Tecnovix.Repo.Migrations.SyncUsers do
  use Ecto.Migration

  def change do
    create table(:sync_users) do
      add :username, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
