defmodule Tecnovix.Resource.Wirecard.Order do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :string, []}
  embedded_schema do
    field :ownId, :string

    embeds_one :amount, Amount do
      field :currency, :string

      embeds_one :subtotals, Subtotals do
        field :shipping, :integer
        field :addition, :integer
        field :discount, :integer
      end
    end

    embeds_many :items, Item do
      field :product, :string
      field :category, :string
      field :quantity, :integer
      field :detail, :string
      field :price, :integer
    end

    embeds_one :customer, Tecnovix.Resource.Wirecard.Cliente

    embeds_many :receivers, Receivers do
      field :type, :string
      field :feePayor, :boolean

      embeds_one :moipAccount, MoipAccount, primary_key: false do
        field :id, :string
      end

      embeds_one :amount, Amount do
        field :fixed, :integer
        field :percentual, :decimal
      end
    end
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:ownId])
    |> cast_embed(:amount, with: &amount_changeset/2)
    |> cast_embed(:items, with: &item_changeset/2)
    |> cast_embed(:customer)
    |> cast_embed(:receivers, with: &receiver_changeset/2)
    |> validate_required([:ownId, :amount, :items, :customer, :receivers])
  end

  defp amount_changeset(changeset, params) do
    changeset
    |> cast(params, [:currency])
    |> cast_embed(:subtotals, with: &subtotals_changeset/2)
    |> validate_required([:currency, :subtotals])
    |> validate_inclusion(:currency, ["BRL"])
  end

  defp subtotals_changeset(changeset, params) do
    changeset
    |> cast(params, [:shipping, :addition, :discount])
    |> validate_number(:shipping, greater_than: 0)
    |> validate_number(:addition, greater_than: 0)
    |> validate_number(:discount, greater_than: 0)
  end

  defp item_changeset(changeset, params) do
    changeset
    |> cast(params, [:product, :category, :quantity, :detail, :price])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_required([:product, :quantity, :price])
  end

  defp receiver_changeset(changeset, params) do
    changeset
    |> cast(params, [:type, :feePayor])
    |> cast_embed(:moipAccount, with: &moip_account_changeset/2)
    |> cast_embed(:amount, with: &receiver_amount_changeset/2)
    |> validate_inclusion(:type, ["PRIMARY", "SECONDARY"])
  end

  defp receiver_amount_changeset(changeset, params) do
    changeset
    |> cast(params, [:fixed, :percentual])
    |> validate_number(:fixed, greater_than: 0)
    |> validate_number(:percentual, greater_than: 0, less_than: 100)
  end

  defp moip_account_changeset(changeset, params) do
    changeset
    |> cast(params, [:id])
    |> validate_required([:id])
  end
end
