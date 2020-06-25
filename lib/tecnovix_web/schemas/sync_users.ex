defmodule Tecnovix.SyncUsersSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sync_users" do
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password_hash, :password])
    |> validate_required([:username, :password_hash])
  end
end
