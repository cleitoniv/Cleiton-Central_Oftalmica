defmodule Tecnovix.LogsClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.ClientesSchema
  alias Tecnovix.UsuariosClienteSchema

  schema "logs_cliente" do
    belongs_to :cliente, ClientesSchema
    field :uid, :string, autogenerate: {Ecto.UUID, :autogenerate, []}
    belongs_to :usuario_cliente, UsuariosClienteSchema, on_replace: :delete
    field :data, :utc_datetime, autogenerate: {DateTime, :truncate, [DateTime.utc_now(), :second]}
    field :ip, :string
    field :dispositivo, :string
    field :acao_realizada, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :cliente_id,
      :usuario_cliente_id,
      :uid,
      :data,
      :ip,
      :dispositivo,
      :acao_realizada
    ])
    |> validate_required([:cliente_id])
  end
end
