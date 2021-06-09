defmodule Tecnovix.Repo.Migrations.ProposalItems do
  use Ecto.Migration

  def change do
    create table(:proposal_items) do
      add :product, :string
      add :price, :integer
      add :quantity, :integer
      add :price_total, :integer
      add :method_payment, :string

      timestamps(type: :utc_datetime)
    end
  end
end
