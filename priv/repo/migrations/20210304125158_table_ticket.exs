defmodule Tecnovix.Repo.Migrations.TableTicket do
  use Ecto.Migration

  def change do
    create table(:ticket) do
      add :email, :string
      add :categoria, :string
      add :descricao, :text
      add :nome, :string
      add :status, :integer

      timestamps()
    end
  end
end
