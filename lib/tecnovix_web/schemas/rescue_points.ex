defmodule Tecnovix.RescuePointsSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rescue_points" do
    belongs_to :cliente, Tecnovix.ClientesSchema
    field :points, :integer
    field :credit_finan, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :points, :credit_finan])
    |> validate_required(:cliente_id)
  end
end
