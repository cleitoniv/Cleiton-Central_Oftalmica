defmodule Tecnovix.App.OffersModel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :value, :integer
    field :installmentCount, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :installmentCount])
    |> validate_required([:value, :installmentCount])
  end
end
