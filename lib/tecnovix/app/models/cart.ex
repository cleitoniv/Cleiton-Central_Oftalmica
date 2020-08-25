defmodule Tecnovix.App.CartModel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :rate, :integer
    field :total, :integer

    embeds_many :products, Products do
      field :title, :string
      field :value, :integer
      field :quantity, :integer
      field :buy_type, :string
    end
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:rate, :total])
    |> cast_embed(:products)
    |> validate_required([:rate, :total, :products])
  end
end
