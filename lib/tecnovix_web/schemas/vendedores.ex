defmodule Tecnovix.VendedoresSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vendedores" do
    field :uid, :string
    field :codigo, :string
    field :nome, :string
    field :sit_app, :string, default: "E"
    field :cnpj_cpf, :string
    field :email, :string
    field :regiao, :string
    field :ddd, :string
    field :telefone, :string
    field :status, :integer, default: 1

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
      :ddd,
      :telefone,
      :status
    ])
    |> validate_required([:cnpj_cpf, :email, :telefone, :ddd, :nome, :regiao], message: "Não pode ficar em branco.")
    |> unique_constraint(:vendedores_constraint)
    |> unique_constraint(:cnpj_cpf, message: "Esse CNPJ ou CPF já existe.")
    |> unique_constraint(:email, message: "Esse email já existe.")
    |> unique_constraint([:ddd, :telefone],
      message: "Esse número de telefone já existe.",
      name: :telefone_ddd_vendedor
    )
  end
end
