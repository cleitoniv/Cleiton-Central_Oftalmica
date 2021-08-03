defmodule Tecnovix.ProposalItemsSchema do
  import Ecto.Changeset
  use Ecto.Schema

  schema "proposal_items" do
    field :product, :string
    field :price, :integer
    field :quantity, :integer
    field :price_total, :integer
    field :method_payment, :string

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:product, :price, :quantity, :price_total, :method_payment])
  end
end
