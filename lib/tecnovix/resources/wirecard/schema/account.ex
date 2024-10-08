defmodule Tecnovix.Resource.Wirecard.Account do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    embeds_one :email, Email do
      field :address, :string
    end

    embeds_one :person, Person do
      field :name, :string
      field :lastName, :string

      embeds_one :taxDocument, TaxDocument do
        field :type, :string
        field :number, :string
      end

      embeds_one :identityDocument, IdentityDocument do
        field :type, :string
        field :number, :string
        field :issuer, :string
        field :issueDate, :date
      end

      field :birthDate, :date
      field :nationality, :string

      embeds_one :parentsName, ParentsName do
        field :mother, :string
        field :father, :string
      end

      embeds_many :alternativePhones, AlternativePhones do
        field :countryCode, :string
        field :areaCode, :string
        field :number, :string
      end

      embeds_one :phone, Phone do
        field :countryCode, :string
        field :areaCode, :string
        field :number, :string
      end

      embeds_one :address, Address do
        field :street, :string
        field :streetNumber, :string
        field :complement, :string
        field :district, :string
        field :zipCode, :string
        field :city, :string
        field :state, :string
        field :country, :string
      end
    end

    field :type, :string
    field :transparentAccount, :boolean
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:type, :transparentAccount])
    |> cast_embed(:email, with: &email_changeset/2)
    |> cast_embed(:person, with: &person_changeset/2)
    |> validate_required([:transparentAccount, :type, :email, :person])
    |> validate_inclusion(:type, ["COSUMER", "MERCHANT"])
  end

  defp email_changeset(changeset, params) do
    changeset
    |> cast(params, [:address])
    |> validate_required([:address])
  end

  defp person_changeset(changeset, params) do
    changeset
    |> cast(params, [:name, :lastName, :birthDate])
    |> cast_embed(:phone, with: &phone_changeset/2)
    |> cast_embed(:parentsName, with: &parents_changeset/2)
    |> cast_embed(:alternativePhones, with: &phone_changeset/2)
    |> cast_embed(:address, with: &address_changeset/2)
    |> cast_embed(:identityDocument, with: &identity_changeset/2)
    |> cast_embed(:taxDocument, with: &tax_changeset/2)
    |> validate_required([:birthDate, :phone, :address, :identityDocument, :taxDocument])
  end

  def parents_changeset(changeset, params) do
    changeset
    |> cast(params, [:mother, :father])
    |> validate_required([:mother, :father])
  end

  defp phone_changeset(changeset, params) do
    changeset
    |> cast(params, [:countryCode, :areaCode, :number])
    |> validate_required([:countryCode, :areaCode, :number])
    |> validate_inclusion(:countryCode, ["55"])
  end

  defp address_changeset(changeset, params) do
    changeset
    |> cast(params, [
      :street,
      :streetNumber,
      :complement,
      :district,
      :zipCode,
      :city,
      :country,
      :state
    ])
    |> validate_required([:street, :streetNumber, :district, :zipCode, :city, :country, :state])
    |> validate_length(:state, is: 2)
    |> validate_length(:country, is: 3)
  end

  defp identity_changeset(changeset, params) do
    changeset
    |> cast(params, [:number, :issuer, :issueDate, :type])
    |> validate_inclusion(:type, ["RG"])
  end

  defp tax_changeset(changeset, params) do
    changeset
    |> cast(params, [:type, :number])
    |> validate_required([:type, :number])
    |> validate_inclusion(:type, ["CPF"])
  end
end
