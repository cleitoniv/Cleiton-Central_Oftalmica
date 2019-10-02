defmodule Tecnovix.Resource.Wirecard.Payment do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :installmentCount, :integer
    field :statementDescriptor, :string

    embeds_one :escrow, Escrow do
      field :description, :string
    end

    embeds_one :fundingInstrument, FundingInstrument do
      field :method, :string

      embeds_one :creditCard, CreditCard do
        field :number, :string
        field :expirationMonth, :string
        field :expirationYear, :string
        field :cvc, :string
        field :hash, :string
        field :store, :boolean

        embeds_one :holder, Holder do
          field :fullname, :string
          field :birthdate, :date

          embeds_one :phone, Phone do
            field :countryCode, :string
            field :areaCode, :string
            field :number, :string
          end

          embeds_one :taxDocument, TaxDocument do
            field :type, :string
            field :number, :string
          end

          embeds_one :billingAddress, BillingAddress do
            field :city, :string
            field :district, :string
            field :street, :string
            field :streetNumber, :string
            field :zipCode, :string
            field :state, :string
            field :country, :string
            field :complement, :string
          end
        end
      end

      embeds_one :boleto, Boleto do
        field :expirationDate

        embeds_one :instructionLines, InstructionLines do
          field :first, :string
          field :second, :string
          field :third, :string
        end

        field :logoUri, :string
      end
    end

    embeds_one :device, Device do
      field :ip, :string

      embeds_one :geolocation, GeoLocation do
        field :latitude, :decimal
        field :longitude, :decimal
      end

      field :userAgent, :string
      field :fingerprint, :string
    end
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:installmentCount, :statementDescriptor])
    |> cast_embed(:fundingInstrument, with: &funding_inst_changeset/2)
    |> cast_embed(:escrow, with: &escrow_changeset/2)
    |> cast_embed(:device, with: &device_changeset/2)
  end

  def escrow_changeset(changeset, params) do
    changeset
    |> cast(params, [:description])
    |> validate_required([:description])
  end

  defp funding_inst_changeset(changeset, params) do
    changeset
    |> cast(params, [:method])
    |> cast_embed(:creditCard, with: &credit_card_changeset/2)
    |> cast_embed(:boleto, with: &boleto_changeset/2)
  end

  defp credit_card_changeset(changeset, params) do
    cond do
      Map.has_key?(params, "hash") ->
        changeset
        |> cast(params, [:hash, :store])
        |> cast_embed(:holder, with: &holder_changeset/2)

      Map.has_key?(params, "id") ->
        changeset
        |> cast(params, [:id, :store])
        |> cast_embed(:holder, with: &holder_changeset/2)

      true ->
        changeset
        |> cast(params, [:number, :expirationMonth, :expirationYear, :cvc, :store])
        |> cast_embed(:holder, with: &holder_changeset/2)
    end
  end

  defp holder_changeset(changeset, params) do
    changeset
    |> cast(params, [:fullname, :birthdate])
    |> cast_embed(:taxDocument, with: &tax_changeset/2)
    |> cast_embed(:phone, with: &phone_changeset/2)
    |> cast_embed(:billingAddress, with: &billing_changeset/2)
  end

  defp tax_changeset(changeset, params) do
    changeset
    |> cast(params, [:type, :number])
  end

  defp phone_changeset(changeset, params) do
    changeset
    |> cast(params, [:countryCode, :areaCode, :number])
    |> validate_required([:countryCode, :areaCode, :number])
  end

  def billing_changeset(changeset, params) do
    changeset
    |> cast(params, [:streetNumber, :complement, :district, :city, :state, :country, :zipCode])
    |> validate_required([:streetNumber, :distrcit, :city, :state, :country, :zipCode])
  end

  defp boleto_changeset(changeset, params) do
    changeset
    |> cast(params, [:expirationDate, :logoUri])
    |> cast_embed(:instructionLines, with: &instruction_changeset/2)
    |> validate_required([:expirationDate])
  end

  defp instruction_changeset(changeset, params) do
    changeset
    |> cast(params, [:first, :second, :third])
  end

  defp device_changeset(changeset, params) do
    changeset
    |> cast(params, [:ip, :userAgent, :fingerprint])
    |> cast_embed(:geolocation, with: &geolocation_changeset/2)
  end

  defp geolocation_changeset(changeset, params) do
    changeset
    |> cast(params, [:latitude, :longitude])
    |> validate_required([:latitude, :longitude])
  end
end
