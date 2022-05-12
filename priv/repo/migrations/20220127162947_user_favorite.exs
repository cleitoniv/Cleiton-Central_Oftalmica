defmodule Tecnovix.Repo.Migrations.UserFavorite do
  use Ecto.Migration

  def change do
    create table(:user_favorite) do
      add :group, :string
      add :user_id, references(:clientes)
    end
  end
end
