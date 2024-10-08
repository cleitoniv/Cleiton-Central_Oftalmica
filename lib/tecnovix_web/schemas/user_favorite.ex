defmodule Tecnovix.UserFavoriteSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_favorite" do
    belongs_to :user, Tecnovix.ClientesSchema
    field :group, :string
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:group, :user_id])
    |> validate_required([:group, :user_id])
  end
end
