defmodule Tecnovix.AgendaSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agendas" do
    belongs_to :cliente, Tecnovix.ClientesSchema
    belongs_to :vendedor, Tecnovix.VendedoresSchema
    field :date, :string
    field :turno_manha, :boolean, default: false
    field :turno_tarde, :boolean, default: false
    field :temporizador, :string
    field :visitado, :integer, default: 0

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :cliente_id,
      :date,
      :turno_manha,
      :turno_tarde,
      :temporizador,
      :visitado,
      :vendedor_id
    ])
    |> validate_required([:date, :cliente_id, :vendedor_id])
  end
end
