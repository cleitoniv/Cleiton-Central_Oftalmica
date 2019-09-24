defmodule Tecnovix.Resource.Wirecard.Cliente do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :string, []}
  embedded_schema do
    field :ownId, :string
    field :fullname, :string
    field :email, :string
    field :birthDate, :date

    embeds_one :taxDocument, TaxDocument do
      field :type, :string
      field :number, :string
    end

    embeds_one :phone, Phone do
      field :countryCode, :string
      field :areaCode, :string
      field :number, :string
    end

    embeds_one :shippingAddress, ShippingAddress do
      field :city, :string
      field :complement, :string
      field :district, :string
      field :street, :string
      field :streetNumber, :string
      field :zipCode, :string
      field :state, :string
      field :country, :string
    end
  end

  def changeset(changeset, params \\ %{}) do
    case Map.has_key?(params, "id") do
      true ->
        changeset
        |> cast(params, [:id])
        |> validate_required([:id])

      false ->
        changeset
        |> cast(params, [:id, :ownId, :fullname, :email, :birthDate])
        |> cast_embed(:taxDocument, with: &tax_changeset/2)
        |> cast_embed(:phone, with: &phone_changeset/2)
        |> cast_embed(:shippingAddress, with: &shipping_changeset/2)
        |> validate_required([
          :ownId,
          :fullname,
          :email,
          :birthDate,
          :taxDocument,
          :phone,
          :shippingAddress
        ])
    end
  end

  def tax_changeset(changeset, params) do
    changeset
    |> cast(params, [:type, :number])
    |> validate_required([:type, :number])
    |> validate_length(:number, max: 11)
    |> validate_length(:type, max: 4)
    |> validate_inclusion(:type, ["CPF", "CNPJ"])
  end

  def phone_changeset(changeset, params) do
    changeset
    |> cast(params, [:countryCode, :areaCode, :number])
    |> validate_required([:countryCode, :areaCode, :number])
    |> validate_inclusion(:countryCode, ["55"])
    |> validate_length(:countryCode, max: 2)
    |> validate_length(:areaCode, max: 2)
    |> validate_length(:number, max: 16)
  end

  def shipping_changeset(changeset, params) do
    changeset
    |> cast(params, [:streetNumber, :complement, :district, :city, :state, :country, :zipCode])
    |> validate_length(:district, max: 45)
    |> validate_length(:state, max: 32)
    |> validate_length(:zipCode, max: 20)
    |> validate_required([
      :streetNumber,
      :complement,
      :state,
      :district,
      :city,
      :country,
      :zipCode
    ])
  end
end
