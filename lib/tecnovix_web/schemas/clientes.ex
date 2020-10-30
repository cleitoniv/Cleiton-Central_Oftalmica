defmodule Tecnovix.ClientesSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clientes" do
    field :uid, :string
    field :codigo, :string
    field :code_sms, :integer
    field :confirmation_sms, :integer, default: 0
    field :loja, :string
    field :fisica_jurid, :string
    field :cnpj_cpf, :string
    field :data_nascimento, :date
    field :nome, :string
    field :nome_empresarial, :string
    field :email, :string
    field :email_fiscal, :string
    field :email_protheus, :string
    field :endereco, :string
    field :numero, :string
    field :complemento, :string
    field :bairro, :string
    field :estado, :string
    field :cep, :string
    field :cdmunicipio, :string
    field :municipio, :string
    field :ddd, :string
    field :telefone, :string
    field :bloqueado, :string, default: "2"
    field :sit_app, :string, default: "E"
    field :cod_cnae, :string
    field :ramo, :string
    field :vendedor, :string
    field :crm_medico, :string
    field :dia_remessa, :string
    field :wirecard_cliente_id, :string
    field :fcm_token, :string
    field :cadastrado, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ {}) do
    struct
    |> cast(params, [
      :uid,
      :codigo,
      :loja,
      :fisica_jurid,
      :cnpj_cpf,
      :email_fiscal,
      :email_protheus,
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
      :estado,
      :ddd,
      :telefone,
      :bloqueado,
      :sit_app,
      :cod_cnae,
      :ramo,
      :vendedor,
      :crm_medico,
      :dia_remessa,
      :wirecard_cliente_id,
      :fcm_token,
      :cadastrado
    ])
    |> validate_required([:fisica_jurid, :cnpj_cpf, :email], message: "Não pode estar em branco.")
    |> validate_inclusion(:fisica_jurid, ["F", "J"])
    |> unique_constraint([:uid], message: "UID já existe")
    |> unique_constraint([:codigo, :loja], message: "Codigo e Loja já existe", name: :loja_codigo)
    |> unique_constraint([:email], message: "Esse email já existe")
    |> unique_constraint([:cnpj_cpf], message: "Esse CNPJ/CPF já existe")
    |> unique_constraint([:telefone], message: "Esse número de telefone já existe")
    |> validations_fisic_jurid(params)
  end

  def sms(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:code_sms, :confirmation_sms, :telefone, :ddd])
    |> validate_required([:telefone, :code_sms])
    |> unique_constraint([:telefone], message: "Esse número de telefone já existe")
  end

  def first_access(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :nome,
      :email,
      :email_fiscal,
      :telefone,
      :cadastrado
    ])
    |> validate_required([:nome, :email, :telefone, :cadastrado],
      message: "Não pode estar em branco."
    )
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:uid], message: "UID já existe")
    |> unique_constraint([:codigo, :loja], message: "Codigo e Loja já existe", name: :loja_codigo)
    |> unique_constraint([:email], message: "Esse email já existe")
    |> unique_constraint([:cnpj_cpf], message: "Esse CNPJ/CPF já existe")
    |> unique_constraint([:telefone], message: "Esse número de telefone já existe")
  end

  def validate_ramo_fisica(changeset, params \\ %{}) do
    case params["ramo"] do
      "2" -> validate_required(changeset, :crm_medico)
      _ -> changeset
    end
  end

  def validate_ramo_juridica(changeset, params \\ %{}) do
    case params["ramo"] do
      "2" -> validate_required(changeset, :cod_cnae)
      _ -> changeset
    end
  end

  def validations_fisic_jurid(changeset, params \\ %{}) do
    case params["fisica_jurid"] do
      "F" ->
        changeset
        |> validate_required(
          [
            :nome,
            :email,
            :email_fiscal,
            :ddd,
            :telefone,
            :data_nascimento,
            :ramo,
            :fisica_jurid,
            :cnpj_cpf,
            :endereco,
            :numero,
            :bairro,
            :estado,
            :cep,
            :municipio,
            :crm_medico
          ],
          message: "Não pode estar em branco."
        )
        |> validate_ramo_fisica(params)
        |> unique_constraint([:uid], message: "UID já existe")
        |> unique_constraint([:codigo, :loja],
          message: "Codigo e Loja já existe",
          name: :loja_codigo
        )
        |> unique_constraint([:email], message: "Esse email já existe")
        |> unique_constraint([:cnpj_cpf], message: "Esse CNPJ/CPF já existe")
        |> unique_constraint([:telefone], message: "Esse número de telefone já existe")

      "J" ->
        changeset
        |> validate_required(
          [
            :nome,
            :email,
            :email_fiscal,
            :ddd,
            :telefone,
            :data_nascimento,
            :ramo,
            :fisica_jurid,
            :cnpj_cpf,
            :nome_empresarial,
            :endereco,
            :numero,
            :estado,
            :bairro,
            :cep,
            :municipio
          ],
          message: "Não pode estar em branco."
        )
        |> validate_ramo_juridica(params)
        |> unique_constraint([:uid], message: "UID já existe")
        |> unique_constraint([:codigo, :loja],
          message: "Codigo e Loja já existe",
          name: :loja_codigo
        )
        |> unique_constraint([:email], message: "Esse email já existe")
        |> unique_constraint([:cnpj_cpf], message: "Esse CNPJ/CPF já existe")
        |> unique_constraint([:telefone], message: "Esse número de telefone já existe")

      _ ->
        changeset
    end
  end
end
