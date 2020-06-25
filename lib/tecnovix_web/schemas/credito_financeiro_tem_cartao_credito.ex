defmodule Tecnovix.CreditoFinanceiroTemCartaoCreditoSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credito_financeiro_tem_cartao_credito" do
    field :credito_financeiro_id, :integer
    field :cartao_credito_id, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:credito_financeiro_id, :cartao_credito_id])
    |> validate_required([:credito_financeiro_id, :cartao_credito_id])
  end
end
