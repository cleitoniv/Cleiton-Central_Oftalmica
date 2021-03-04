defmodule Tecnovix.TicketSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ticket" do
    field :nome, :string
    field :email, :string
    field :descricao, :string
    field :categoria, :string
    field :status, :integer, default: 0

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:nome, :email, :descricao, :categoria, :status])
    |> validate_required([:nome, :email, :descricao, :categoria])
  end
end
