defmodule Tecnovix.ProposalSchema do
  import Ecto.Changeset
  use Ecto.Schema

  alias Tecnovix.ClientesSchema
  alias Tecnovix.ProposalItemsSchema
  alias Tecnovix.VendedoresSchema

  schema "proposal" do
    belongs_to :cliente, ClientesSchema
    belongs_to :proposal_items, ProposalItemsSchema
    belongs_to :vendedor, VendedoresSchema
    field :proposal_date, :date
    field :proposal_number, :integer
    field :responsible, :string
    field :contact, :string
    field :note, :string

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :vendedor_id,
      :cliente_id,
      :proposal_items,
      :proposal_date,
      :proposal_number,
      :responsible,
      :contact,
      :proposal_items_id,
      :note
    ])
    |> validate_required([:cliente_id, :vendedor_id])
    |> unique_constraint(:proposal_number, message: "Essa proposta já existe.")
  end
end
