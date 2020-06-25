defmodule Tecnovix.VendedoresSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vendedores" do
    field :uid, :string
    field :codigo, :string
    field :nome, :string
    field :sit_app, :string
    field :cnpj_cpf, :string
    field :email, :string
    field :regiao, :string
    field :celular, :string
    field :status, :string
    field :moip_account_id, :string
    field :moip_acess_token, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :uid,
      :codigo,
      :nome,
      :sit_app,
      :cnpj_cpf,
      :email,
      :regiao,
      :celular,
      :status,
      :moip_account_id,
      :moip_acess_token
    ])
    |> validate_required([:codigo, :cnpj_cpf])
  end
end
