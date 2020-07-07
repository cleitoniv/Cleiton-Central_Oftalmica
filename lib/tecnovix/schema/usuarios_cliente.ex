defmodule Tecnovix.UsuariosClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.ClientesSchema

  schema "usuarios_cliente" do
    belongs_to :cliente, ClientesSchema
    field :uid, :string
    field :nome, :string
    field :email, :string
    field :cargo, :string
    field :status, :integer, default: 1
    field :senha_enviada, :integer, default: 0

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :uid, :nome, :email, :cargo, :status])
    |> validate_required([:cliente_id, :nome, :email, :status])
  end

  def update(struct, params \\ %{}) do
    struct
    |> cast(params, [:nome, :cargo])
  end

  def update_senha(struct, params \\ %{}) do
    struct
    |> cast(params, [:senha_enviada])
  end

  def update_status(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
  end
end
