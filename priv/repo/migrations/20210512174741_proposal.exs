defmodule Tecnovix.Repo.Migrations.Proposal do
  use Ecto.Migration

  def change do
    create table(:proposal) do
      add :vendedor_id, references(:vendedores)
      add :cliente_id, references(:clientes)
      add :proposal_date, :date
      add :proposal_number, :integer
      add :responsible, :string
      add :contact, :string
      add :proposal_items_id, references(:proposal_items)
      add :note, :string

      timestamps()
    end

    create unique_index(:proposal, [:proposal_number])
  end
end
