defmodule Tecnovix.UsuariosClienteSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tecnovix.ClientesSchema

  schema "usuarios_cliente" do
    belongs_to :cliente, ClientesSchema
    field :uid, :string
    field :nome, :string
    field :email, :string
    field :password, :string, virtual: true
    field :cargo, :string
    field :status, :integer, default: 1
    field :senha_enviada, :integer, default: 0
    field :role, :string, default: "USUARIO"
    has_many :logs_cliente, Tecnovix.LogsClienteSchema, foreign_key: :usuario_cliente_id, on_delete: :nilify_all

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cliente_id, :uid, :nome, :email, :cargo, :status, :password, :role])
    |> validate_required([:cliente_id, :nome, :email, :status])
    |> validate_length(:nome, max: 15, message: "Não pode ser maior que 15 caracteres")
    |> unique_constraint(:email, message: "Esse email ja esta cadastrado.")
  end

  def update(struct, params \\ %{}) do
    struct
    |> cast(params, [:nome, :cargo, :status])
  end

  def update_senha(struct, params \\ %{}) do
    struct
    |> cast(params, [:senha_enviada])
  end
end
