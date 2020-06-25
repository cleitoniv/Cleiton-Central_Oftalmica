defmodule Tecnovix.UsuariosClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "usuarios_cliente" do
    field :cliente_id, :integer
    field :uid, :integer
    field :nome, :string
    field :email, :string
    field :cargo, :string
    field :status, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,[:cliente_id, :uid, :nome, :email, :cargo, :status])
    |> validate_required([:cliente_id, :uid, :nome, :email, :status])
  end
end
