defmodule Tecnovix.Resource.Wirecard.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :string, []}
  embedded_schema do
    field :method, :string
    field :store, :boolean

    embeds_one :creditCard, CreditCard do
      field :expirationMonth, :string
      field :expirationYear, :string
      field :number, :string
      field :cvc, :string

      embeds_one :holder, Holder do
        field :fullname, :string
        field :birthdate, :date

        embeds_one :taxDocument, TaxDocument do
          field :type, :string
          field :number, :string
        end

        embeds_one :phone, Phone do
          field :countryCode, :string
          field :areaCode, :string
          field :number, :string
        end

        embeds_one :billingAddress, BillingAddress do
          field :city, :string
          field :district, :string
          field :street, :string
          field :streetNumber, :string
          field :zipCode, :string
          field :state, :string
          field :coutry, :string
        end
      end
    end
  end

  def changeset(changeset, params \\ %{}) do
      changeset
      |> cast(params, [:method])
      |> cast_embed(:creditCard, with: &credit_card_changeset/2)
      |> validate_inclusion(:method, ["CREDIT_CARD"])
      |> validate_required([:method, :creditCard])
  end

  defp credit_card_changeset(changeset, params) do
    changeset
    |> cast(params, [:expirationMonth, :expirationYear, :number, :cvc])
    |> cast_embed(:holder, with: &holder_changeset/2)
    |> validate_required([:expirationMonth, :expirationYear, :number, :cvc, :holder])
    |> validate_length(:number, max: 18)
    |> validate_length(:expirationYear, max: 4)
    |> validate_length(:expirationMonth, max: 2)
  end

  def holder_changeset(changeset, params) do
    changeset
    |> cast(params, [:fullname, :birthdate])
    |> cast_embed(:taxDocument, with: &tax_changeset/2)
    |> cast_embed(:phone, with: &phone_changeset/2)
    |> cast_embed(:billingAddress, with: &Tecnovix.Resource.Wirecard.Cliente.shipping_changeset/2)
    |> validate_required([:fullname, :birthdate, :taxDocument, :phone])
    |> validate_length(:fullname, max: 65)
  end

  defp tax_changeset(changeset, params) do
    changeset
    |> cast(params, [:type, :number])
    |> validate_required([:type, :number])
    |> validate_inclusion(:type, ["CPF", "CNPJ"])
    |> validate_length(:number, max: 14)
  end

  defp phone_changeset(changeset, params) do
    changeset
    |> cast(params, [:countryCode, :areaCode, :number])
    |> validate_required([:countryCode, :areaCode, :number])
    |> validate_length(:countryCode, max: 2)
    |> validate_length(:areaCode, max: 2)
    |> validate_length(:number, max: 16)
  end
end
