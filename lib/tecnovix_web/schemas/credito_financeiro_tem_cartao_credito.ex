defmodule Tecnovix.CreditoFinanceiroTemCartaoCreditoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credito_financeiro_tem_cartao_credito" do
    belongs_to :credito_financeiro, Tecnovix.CreditoFinanceiroSchema
    belongs_to :cartao_credito, Tecnovix.CartaoCreditoClienteSchema

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:credito_financeiro_id, :cartao_credito_id])
    |> validate_required([:credito_financeiro_id, :cartao_credito_id])
  end
end
