defmodule Tecnovix.OpcoesCompraCreditoFinanceiroSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "opcoes_compra_credito_financeiro" do
    field :valor, :integer
    field :desconto, :integer
    field :prestacoes, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:valor, :desconto, :prestacoes])
    |> validate_required([:valor, :prestacoes])
  end
end
