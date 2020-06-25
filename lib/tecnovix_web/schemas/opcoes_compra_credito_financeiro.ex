defmodule Tecnovix.OpcoesCompraCreditoFinanceiroSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "opcoes_compra_credito_financeiro" do
    field :valor, :decimal
    field :desconto, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:valor, :desconto])
    |> validate_required([:valor])
  end
end
