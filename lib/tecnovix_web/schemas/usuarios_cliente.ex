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
    field :status, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,[:cliente_id, :uid, :nome, :email, :cargo, :status])
    |> validate_required([:cliente_id, :nome, :email, :status])
  end
end
