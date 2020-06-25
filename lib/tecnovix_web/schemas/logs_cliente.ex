defmodule Tecnovix.LogsClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs_cliente" do
    field :cliente_id, :integer
    field :usuario_cliente_id, :integer
    field :data, :utc_datetime
    field :ip, :string
    field :dispositivo, :string
    field :acao_realizada, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :usuario_cliente_id, :date, :ip, :dispositivo, :acao_realizada])
    |> validate_required([:cliente_id, :data,])
  end
end
