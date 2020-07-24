defmodule Tecnovix.ClientesSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clientes" do
    field :uid, :string
    field :codigo, :string
    field :loja, :string
    field :fisica_jurid, :string
    field :cnpj_cpf, :string
    field :data_nascimento, :date
    field :nome, :string
    field :nome_empresarial, :string
    field :email, :string
    field :endereco, :string
    field :numero, :string
    field :complemento, :string
    field :bairro, :string
    field :cep, :string
    field :cdmunicipio, :string
    field :municipio, :string
    field :ddd, :string
    field :telefone, :string
    field :bloqueado, :string
    field :sit_app, :string
    field :cod_cnae, :string
    field :ramo, :string
    field :vendedor, :string
    field :crm_medico, :string
    field :dia_remessa, :string
    field :wirecard_client_id, :string
    field :fcm_token, :string

    timestamps()
  end

  def changeset(struct, params \\ {}) do
    struct
    |> cast(params, [
      :uid,
      :codigo,
      :loja,
      :fisica_jurid,
      :cnpj_cpf,
      :data_nascimento,
      :nome,
      :nome_empresarial,
      :email,
      :endereco,
      :numero,
      :complemento,
      :bairro,
      :cep,
      :cdmunicipio,
      :municipio,
      :ddd,
      :telefone,
      :bloqueado,
      :sit_app,
      :cod_cnae,
      :ramo,
      :vendedor,
      :crm_medico,
      :dia_remessa,
      :wirecard_client_id,
      :fcm_token
    ])
    |> validate_required([:fisica_jurid, :cnpj_cpf, :email])
    |> validate_inclusion(:fisica_jurid, ["F", "J"])
    |> unique_constraint(:email)
    |> unique_constraint(:cnpj_cpf)
    |> unique_constraint(:uid)
    |> unique_constraint(:codigo)
  end

  def validations_fisic_jurid(changeset, params \\ %{}) do
    case params["fisica_jurid"] do
      "F" ->
        changeset
        |> validate_required([
          :nome,
          :email,
          :ddd,
          :telefone,
          :data_nascimento,
          :ramo,
          :fisica_jurid,
          :cnpj_cpf,
          :endereco,
          :numero,
          :bairro,
          :cep,
          :cdmunicipio,
          :municipio,
          :crm_medico
        ])

      "J" ->
        changeset
        |> validate_required([
          :nome,
          :email,
          :ddd,
          :telefone,
          :data_nascimento,
          :ramo,
          :fisica_jurid,
          :cnpj_cpf,
          :nome_empresarial,
          :endereco,
          :numero,
          :bairro,
          :cep,
          :cdmunicipio,
          :municipio,
          :cod_cnae
        ])
    end
  end
end
