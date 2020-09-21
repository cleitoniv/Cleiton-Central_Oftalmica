defmodule Tecnovix.PointsSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :num_serie, :string
    field :paciente, :string
    field :num_pac, :string
    field :dt_nas_pac, :date
    field :points, :integer
    field :status, :integer, default: 0
    field :credit_finan, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:num_serie, :paciente, :num_pac, :dt_nas_pac, :points, :credit_finan, :status])
  end
end
