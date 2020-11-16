defmodule Tecnovix.App.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :total, :integer
    field :cartao_number, :string
    field :x2, :string
    field :x3, :string
    field :x4, :string
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:total, :cartao_number, :x2, :x3, :x4])
    |> validate_required([:total, :cartao_number, :x2, :x3, :x4])
  end
end
