defmodule Tecnovix.App.OrderModel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :paciente, :string
    field :pedido, :string
    field :date, :date
    field :value, :integer
    field :status, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:paciente, :pedido, :date, :value, :status])
    |> validate_required([:paciente, :pedido, :date, :value, :status])
  end
end
