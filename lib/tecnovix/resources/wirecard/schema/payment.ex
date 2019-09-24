defmodule Tecnovix.Resource.Wirecard.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :installmentCount, :integer
    field :statementDescriptor, :string

      embeds_one :fundingInstrument, FundingInstrument do
        field :method, :string

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
    |> cast_embed(:device, with: &device_changeset/2)
  end

  defp funding_inst_changeset(changeset, params) do
    case Map.fetch!(params, "method") do
      "CREDIT_CARD" -> credit_card_changeset(changeset, params)
      "BOLETO" -> boleto_changeset(changeset, params)
    end
  end

  defp identify_type(params, type) do
    Enum.any?(Map.keys(params), fn key -> key == type end)
  end

  defp credit_card_changeset(changeset, params) do

    cond do
      identify_type(params, "hash") ->
        changeset
        |> cast(params, [:hash])
        |> validate_required([:hash])

      identify_type(params, "id") ->
        changeset
        |> cast(params, [:id])
        |> validate_required([:id])
      true ->
        changeset
        |> cast(params, [:method])
        |> cast_embed(:holder, with: &Tecnovix.Resource.Wirecard.CreditCard.holder_changeset/2)
        |> validate_required([:method, :holder])
        |> validate_length(:number, max: 18)
    end
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
