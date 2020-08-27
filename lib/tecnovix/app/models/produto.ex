defmodule Tecnovix.App.ProductModel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :title, :string
    field :value, :integer
    field :image_url, :string
    field :type, :string
    field :material, :string
    field :dk_t, :integer
    field :visint, :string
    field :espessura, :string
    field :hidratacao, :string
    field :assepsia, :string
    field :descarte, :string
    field :desenho, :string
    field :diametro, :string
    field :curva_base, :integer
    field :esferico, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :value, :image_url, :type, :meterial, :dk_t, :visint, :espessura, :hidratacao, :assepsia, :descarte, :desenho, :diametro, :curva_base, :esferico])
    |> validate_required([:title, :value, :image_url, :type])
  end
end
