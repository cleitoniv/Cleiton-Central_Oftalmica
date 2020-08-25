defmodule Tecnovix.App.ProductModel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :tests, :integer
    field :credits, :integer
    field :title, :string
    field :value, :integer
    field :image_url, :string
    field :type, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tests, :credits, :title, :value, :image_url, :type])
    |> validate_required([:tests, :credits, :title, :value, :image_url, :type])
  end
end
