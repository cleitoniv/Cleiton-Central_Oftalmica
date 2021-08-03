defmodule Tecnovix.LogsVendedorSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs_vendedor" do
    belongs_to :vendedor, Tecnovix.VendedoresSchema
    field :data, :utc_datetime
    field :ip, :string
    field :dispositivo, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:vendedor_id, :data, :ip, :dispositivo])
    |> validate_required([:vendedor_id, :data])
  end
end
